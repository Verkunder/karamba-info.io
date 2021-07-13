window.onload = function () {

  let form = $('#register-form');
  let lang = $('#lang').text();

  form.on('submit', function (event) {
    event.preventDefault();
    $.ajax({
      type: 'POST',
      url: $(form).attr('action'),
      data: $(this).serialize()
    })
    .done(function (response) {
      if (response.type === 'success') {
        if (lang === 'ru') {
          window.location.href = '/ru/register/success';
        } else {
          window.location.href = '/register/success';
        }
      }

    }).fail(function (error) {
      let resp = JSON.parse(error.responseText);
      switch (resp.code) {
        case 1062:
          $('#email_warn').removeClass('hidden');
          break;
        default:
          if (lang === 'ru') {
            window.location.href = '/ru/register/error';
          } else {
            window.location.href = '/register/error';
          }
          break;
      }
    })
  });
};
