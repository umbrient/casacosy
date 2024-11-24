class Api   
  
  
  def conn 
    @conn ||= Faraday.new(
      url: self.class::URI,
      headers: { 'Content-Type' => 'application/json', }
  )
  end


end 