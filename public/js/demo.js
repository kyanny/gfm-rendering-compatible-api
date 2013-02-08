$(function(){
    var hostname = $('#hostname').val();

    $('#fire').click(function(){

        var input = $('#input').val();
        if (!input) {
            alert("Please input Markdown");
        }
        $('#progress').text('Processing...');
        $.ajax({
            "type":"POST",
            "url":"http://" + hostname  + "/markdown/raw",
            "data":input,
            "success":function(res){
                $('#output').val(res);
                $('#progress').text('');
            }
        });
    });
});
