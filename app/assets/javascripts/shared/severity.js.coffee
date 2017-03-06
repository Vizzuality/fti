jQuery ->

  changeSeverity = ->
    annex = $('.js-annex-severity :selected').text()

    escaped_annex = annex.replace(/([ #;&,.+*~\':"!^[\]()=>|\/@])/g, '\\$1')
    options = $(severities).filter("optgroup[label='#{escaped_annex}']").html()
    if options
      $('.js-severity').html(options)
      $('.js-severity').parent().show()
    else
      $('.js-severity').empty()
      $('.js-severity').parent().hide()


  severities = $('.js-severity').html()
  if $('.js-annex-severity :selected').text().length == 0
    $('.js-severity').parent().hide()
  else
    changeSeverity()

  $('.js-annex-severity').change -> changeSeverity()
