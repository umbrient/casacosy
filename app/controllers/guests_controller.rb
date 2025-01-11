class GuestsController < ActionController::Base

  DEPOSIT_AMOUNT = 150

  before_action :set_booking, except: [:no_code]

  layout "end_user", only: [:show]

  def update_extras

    @booking.booking_addon_options.unpaid.destroy_all

    items = extras_params rescue nil 

    return unless items 

    

    items.each do |item| 

      item[:option_value] = item.delete(:value).to_s

      addon_option = AddonOption.find_by(id: item[:addon_option_id])
      return unless addon_option 

      # makes sure all items are represented as single-quantity line-items
      # beneficial for "picks 2, pays, picks 1 more, doesn't pay" situations.
      # if all 3 are represented on a singular record, it's trickier to mark as paid true/false etc. =)
      if addon_option.quantifiable?
        if item[:option_value].to_i > 0
          item[:option_value].to_i.times do 
            item[:option_value] = 1
            item[:current_price_pennies] = addon_option.price_pennies_each
            @booking.booking_addon_options.create(item)
          end
          next 
        end
      else  
        item[:current_price_pennies] = addon_option.price_pennies_each
        @booking.booking_addon_options.create(item)
      end


    end
  end

  # obsolete for now
  def switch_extras_payment_method
    new_method = @booking.extras_payment_method == 'deposit' ? 'separate' : 'deposit'
    @booking.update(extras_payment_method: new_method)
    
    return redirect_to("/guests/#{@reservation_id}/#{@code}/4")
  end

  def create_deposit_intent
    payment_intent = stripe_api.create_payment_intent(amount_pennies: DEPOSIT_AMOUNT * 100, description: @booking.deposit_description )
    render json: { client_secret: payment_intent.client_secret }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create_extras_intent
    total = @booking.booking_addon_options.unpaid.sum(:current_price_pennies).to_i
    description = @booking.booking_addon_options.unpaid.map { |ao| ao.addon.name }.join(', ')
    payment_intent = stripe_api.create_payment_intent(amount_pennies: total, description: "Assorted extras - #{description}", capture: true)
    render json: { client_secret: payment_intent.client_secret }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  

  def update_booking
    
    fields = booking_params

    fields.delete :reservation

    if @booking.update(fields)
      return render json: 'Saved' 
    else 
      return render json: 'Woops!' 
    end 
  end

  def show

    @deposit_amount = DEPOSIT_AMOUNT

    # `requests.request` meaning of the requests, get the top item from UNDONE/OPEN requests.
    any_requests = @booking.requests.any? 

    unless any_requests
      SendRequestEmailsJob.new.perform_one(@booking)
    end

    @request = @booking.requests.request.first

    return render plain: "This link has expired." unless @request

    requests = @request.booking.requests.request.not_expired

    @total_steps = 5
    starting_step = 'guest-details'
    force_step = params[:step].to_s

    # return render "check_in_instructions"
    if @booking.requests.request.not_expired.none?
      # either has no requests or bro is ready.
      
      # generate a new keycode?
      @booking.generate_lockbox_code if @booking.lockbox_code.nil?
      @booking.generate_collection_code if @booking.keynest_code.nil?
      return render 'check_in_temp'
    end 
    
    
    
    if !@booking.basic_details_given? || force_step == 'guest-details'
      @step = 1 
      @step_text = 'Guest Details'
      return render 'basic_details'
    elsif requests.id.any? || force_step == 'id'
      @step = 2
      @step_text = 'Upload Your ID'

      if force_step == 'id'
        if @booking.requests.uploaded.any?
          return render 'already_uploaded_id'
        else 
          # idk why you're here?
          # link somehow expired but you haven't uploaded anything?
        end
      else 
        @request = requests.id.last
      end
      
    elsif requests.terms.any? || force_step == 'terms'
      @step = 3
      @step_text = 'Your Signature'

      if force_step == 'terms' 
        if @booking.requests.signed.any?
          return render 'already_signed'
        else 
          # idk why you're here 
        end        
      end

      @request = requests.terms.last


    elsif !@booking.guest_has_viewed_extras? || force_step == 'extras'
      @booking.update(guest_has_viewed_extras: true)
      @step_text = 'Any Extras?'
      @step = 4
      @extras = @booking.apartment.addons.joins(:apartment_addons)
      .where(apartment_addons: { available: true }).distinct

      @selected_extras = @booking.booking_addon_options.unpaid.map do |bao|
        {
          addon_option_id: bao.addon_option_id,
          option_value: bao.addon_option.quantifiable? ? bao.option_value.to_i : bao.option_value,
          type: bao.addon_option.type
        }
      end
      return render 'extras'

    elsif @booking.booking_addon_options.unpaid.any? || force_step == 'pay-extras'
      @step = 4.5
      if @booking.booking_addon_options.unpaid.any?      
        @step = 4.5
        @extras_total = (@booking.booking_addon_options.unpaid.sum(:current_price_pennies) / 100).to_f
        @step_text = 'Oustanding extras payment'
        return render 'pay_extras' 
      end
    elsif requests.deposit.any? || force_step == 'deposit'
      unless @booking.depositable?
        return render 'pre_deposits' 
      end

      if @booking.regular?
        return render 'regular_guest' 
      end

      @step = 5
      @step_text = 'Pay Deposit'
      @request = requests.deposit.last

      if (@booking.arrival - Date.tomorrow).to_i > 1
        @until = @booking.arrival + 1.day
        return render "deposit_too_early"
      end

    else
      render plain: "Please contact your administrator #114."
    end


    render @request.request_type

  end


  def no_deposit 
    if !@booking.depositable? || @booking.regular?
      @booking.requests.request.deposit.not_expired.last.update(expired: true)
    end 
    return redirect_to("/guests/#{@reservation_id}/#{@code}")
  end

  def upload_id
    args = {
      params: params,
      action: 'upload_id'
    }
    result = RequestUpdator.new(args).call
    
    render json: { success: result }
  end 

  def reupload_id 
    args = { 
      booking_id: @booking.id,
      request_type: 'id',
      request_action: 'request',
      user_id: 0
    }

    result = RequestCreator.new(args, true).call
    render json: { success: result }
  end
  

  def pay_deposit
    args = {
      params: params,
      action: 'pay_deposit'
    }
    
    result = RequestUpdator.new(args).call

    if request.post? 
      return render json: { success: result }
    else 
      return redirect_to('/')
    end
  end

  def pay_extras

    args = {
      params: params,
      action: 'pay_extras'
    }
    
    result = RequestUpdator.new(args).call

    if request.post? 
      return render json: { success: result }
    else 
      return redirect_to('/')
    end

  end

  def agree_to_terms
    args = {
      params: params,
      action: 'agree_to_terms'
    }

    result = RequestUpdator.new(args).call
    render json: { success: result }
  end

  def no_code 
    render plain: 'You need to access this page with a code.'
  end 


  private 

  def set_booking
    @reservation_id = params[:reservation_id]
    @code = params[:code].to_i

    @booking = Booking.find_by_reservation_id(@reservation_id)

    return render 'invalid_booking' if (@booking.nil? || @booking.arrival.past? || @booking.auth_code != @code)

  end


  def booking_params 
    params.require(:booking).permit(:guest_input_firstname,:guest_input_lastname,:guest_input_guestcount,:guest_input_email,:guest_input_eta,:guest_input_sofabed,:guest_input_parking, :reservation)
  end

  def extras_params 
    params.require(:_json).map do |item|
      item.permit(:addon_id, :addon_option_id, :value, :notes)
    end
  end


  def stripe_api
    @stripe_api ||= StripeApi.new
  end


end
