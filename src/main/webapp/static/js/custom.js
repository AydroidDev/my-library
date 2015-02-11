/* Support list */

$("#slist a").click(function(e){
   e.preventDefault();
   $(this).next('p').toggle(200);
});

/* Portfolio */

// filter items when filter link is clicked
$('#filters a').click(function(){
  var selector = $(this).attr('data-filter');
  $container.isotope({ filter: selector });
  return false;
});

$(document).ready(function(){
$("a[rel^='prettyPhoto']").prettyPhoto({
overlay_gallery: false, social_tools: false
});

/* Isotope */
$('#isotope').isotope({
  // options...
});
});