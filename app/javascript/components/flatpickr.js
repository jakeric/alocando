import flatpickr from 'flatpickr';

const toggleDateInputs = function() {
  const startDateinput = document.getElementById('inlineFormStartInputDate');
  // const endDateinput = document.getElementById('inlineFormEndInputDate');

  flatpickr(startDateinput, {
    allowInput: true,
    mode: "range",
    minDate: 'today',
    dateFormat: "Y-m-d"
    // onChange: function(_, selectedDate) {
    // // function(_, selectedDate) {
    //   let splitted = selectedDate.split(" to ");
    //   startDateinput.value = splitted[0];
    //   endDateinput.value = splitted[1];
    // }
  });
};

export { toggleDateInputs };
