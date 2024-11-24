import Swal from 'sweetalert2';
import * as bootstrap from 'bootstrap';
import Dropzone from "dropzone";
import SignaturePad from "signature_pad";

Dropzone.autoDiscover = false;

window.bootstrap = bootstrap
window.Dropzone = Dropzone
window.SignaturePad = SignaturePad
window.Swal = Swal


document.addEventListener('DOMContentLoaded', function() {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl, {
    placement: 'top'
  }));
});
