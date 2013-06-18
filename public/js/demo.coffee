$ ->
  hostname = $('#hostname').val()

  $('#fire').click ->
    input = $('#input').val()
    if (!input)
      alert "Please input Markdown"

    $('#progress').text 'Processing...'
    $.ajax "http://" + hostname  + "/markdown/raw",
      type: "POST"
      data: input
      success: (res) ->
        $('#output').val(res)
        $('#progress').text('')
    @
  @
