$(function () {
    atualiza()
});

function atualiza(){
    console.log("Jquery carregado!")

    ativos = $('tr.ativos').each(function(i, ativo){
        var ativo_id = $(ativo).attr("id").replace('ativo_', '')
        console.log(i + ': ' + ativo_id)
    });
    
}