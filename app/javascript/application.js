import Swal from 'sweetalert2';
import * as bootstrap from 'bootstrap';


window.bootstrap = bootstrap
window.Swal = Swal


document.addEventListener('DOMContentLoaded', function() {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl, {
    placement: 'top' // Ensure this is a string like 'top', 'bottom', etc.
  }));
});
