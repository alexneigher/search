//do basic jquery popover
jQuery(function() {
  $("a[rel~=popover], .has-popover").popover();
  return $("a[rel~=tooltip], .has-tooltip").tooltip();
});

//globally, show spinner on form submit
$('form').on('submit', function(){
  original_text = $(this).find('.btn').html;
  alert(original_text)
  //bind_ajax_success($this, original_text);
})