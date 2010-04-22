// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// DoNav script credit to spanjaars.com from http://imar.spaanjaars.com/QuickDocId.aspx?quickdoc=312
    function ChangeColor(tableRow, highLight)
    {
    switch (highLight)
    {
        case 1:
            tableRow.style.backgroundColor = '#dcfac9';
            break;
        case 2:
            tableRow.style.backgroundColor = '#fadcc9';
            break;
        case 3:
            tableRow.style.backgroundColor = 'white';
            break;
        case 4:
            tableRow.style.backgroundColor = '#DADCDF';
            break;
        case 5:
            tableRow.style.backgroundColor = '#FAFCFF';
            break;
        default:
            tableRow.style.backgroundColor = 'white';
    }
  }

  function DoNav(theUrl)
  {
  document.location.href = theUrl;
  }

    function checkAll(field)
    {
    for (i = 0; i < field.length; i++)
            field[i].checked = true ;
    }
    
    function uncheckAll(field)
    {
    for (i = 0; i < field.length; i++)
            field[i].checked = false ;
    }

function toggleAll(name)
{
  boxes = document.getElementsByClassName(name);
  for (i = 0; i < boxes.length; i++)
    if (!boxes[i].disabled)
   		{	boxes[i].checked = !boxes[i].checked ; }
}

function setAll(name,state)
{
  boxes = document.getElementsByClassName(name);
  for (i = 0; i < boxes.length; i++)
    if (!boxes[i].disabled)
   		{	boxes[i].checked = state ; }
}
