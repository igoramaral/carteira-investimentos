$(function () {
    atualiza()
});

function atualiza(){
    console.log("Jquery carregado!")

    ativos = $('tr.ativos').each(function(i, ativo){
        var ativo_id = $(ativo).attr("id").replace('ativo_', '')
        url = "http://localhost:3000/admin/dashboard/calcular_valores?id=" + ativo_id

        $.get(url, function(data) {
            preco = data.preco;
            posicao = data.posicao;
            $('#valor_atual_' + ativo_id).html(preco);
            $('#posicao_atual_' + ativo_id).html(posicao);

            if (posicao >= 0) {
                $('#posicao_atual_' + ativo_id).css("color", "green");
            } else{
                $('#posicao_atual_' + ativo_id).css("color", "red");
            }   

        });
    });
    
}