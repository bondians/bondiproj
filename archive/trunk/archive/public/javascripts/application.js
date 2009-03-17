// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function toggleAll(name)
{
  boxes = document.getElementsByClassName(name);
  for (i = 0; i < boxes.length; i++)
    if (!boxes[i].disabled) {
        boxes[i].checked = !boxes[i].checked ;
    }
}
