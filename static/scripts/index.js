import $ from 'jquery';

$(document).ready(() => {
  console.log('test');

  $.get('/hn').then((resp) => {
    console.log(resp);
  });
});
