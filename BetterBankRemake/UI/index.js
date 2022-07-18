$(document).ready(function(){
    function display(bool) {
        if (bool) {
            $(".bankPanel").show();
        } else {
            $(".bankPanel").hide();
        }
    }

    function AnimationDisplay(bool) {
        if (bool) {
            setTimeout(function(){jQuery('.bankPanel').fadeIn('show')}, 600);
        } else {
            $(".bankPanel").fadeOut(400);
        }
    }

    var amountColorClass = {
        'Deposit': "greenAmountText",
        'Withdraw': "redAmountText"
    }
    var billingDatas = [];
    var openedForCompany = false
    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type == "ui") {
            AnimationDisplay(true)
            billingDatas = []
            openedForCompany = false
            clearTheUI()
            setupNameAmountAndIBAN(item.data)
            
            item.data.LastTransactions.forEach(element => {
                AddTransaction(element)
            });
            item.data.Bills.forEach(element => {
                AddBill(element)
            });
            if (item.openForCompany == true) {
                openedForCompany = true
            }else {
                
            }
        }
        else if(item.type == "addTransaction"){
            AddTransaction(item.transaction)
        } 
        else if(item.type == "message") {
            ShowMessage(item.icon, item.message)
            //BasarisizIslemGoster()
        }else if(item.type == "deleteBill") {
            billingDatas.forEach(element => {
                if (element.id == item.index) {
                    $('input[value="'+ String(billingDatas.indexOf(element)) +'"]').parent().remove()
                }
            })
        }
        else if(item.type = "updateBalance"){
            $("#playerMoneyAmount").html(addCommas((String(item.balance))))
            $("#playerMoneyAmount").append(",00")
            $("#playerMoneyAmount").prepend("$")
        }
    })

    $("#cikis").click(function() {
        AnimationDisplay(false)
        $.post('http://BetterBankRemake/exit', JSON.stringify({}));
        return
    })

    const checkbox = document.getElementById("toggledark")
    var darkMode = false
    checkbox.addEventListener('change', ()=> {
        $(".bankPanel").toggleClass('darkness');
        $("button").toggleClass("darkness");
        $("a").toggleClass("darkness");
        $(".islemZaman").toggleClass("darkness");
        $("#islemler").toggleClass("darkness");
        $(".textislemler").toggleClass("darkness");
        $("#basarili").toggleClass("darkness");
        $(".fatura").toggleClass("darkness");
        $(".islem").toggleClass("darkness");
        if (darkMode == false) {
            darkMode = true
        }else {
            darkMode = false
        }
    });
    
    $("#parayiYatir").click(function(e) { // deposit
        var editedAmount = "$" + addCommas(String($("#yatirText").val())) + ",00";

        $.post('http://BetterBankRemake/deposit', JSON.stringify({
            IBAN: $(".playerIBAN").text(),
            status: 'Deposit',
            amount: $("#yatirText").val(),
            time: GetDateAndTime(),
            comingFrom: '',
            editedAmount: editedAmount,
            openedForCompany: openedForCompany
        }));
    });

    $("#paraCek").click(function(e) {
        var editedAmount = "$" + addCommas(String($("#cekText").val())) + ",00";

        $.post('http://BetterBankRemake/withdraw', JSON.stringify({
            IBAN: $(".playerIBAN").text(),
            status: 'Withdraw',
            amount: $("#cekText").val(),
            time: GetDateAndTime(),
            comingFrom: '',
            editedAmount: editedAmount,
            openedForCompany: openedForCompany
        }));
    });

    $("#IBANParaGonder").click(function(e) {
        let IBANval = $("#targetIBAN").val()
        let miktar = $("#targetAmount").val()
        
        let senderIBAN = $(".playerIBAN").text()

        var editedAmount = "$" + addCommas(String(miktar)) + ",00";

        if (IBANval != "" && miktar > 0 && IBANval != senderIBAN)
        {
            $.post('http://BetterBankRemake/transfer', JSON.stringify({
                targetIBAN: IBANval.toUpperCase(),
                amount: miktar,
                senderIBAN: senderIBAN,
                time: GetDateAndTime(),
                editedAmount: editedAmount,
                openedForCompany: openedForCompany
            }));
        }
    });

    $(document).on('click', '.faturaOdeButton', function () {
        var index = $(this).next().val()        // index
        $.post('http://BetterBankRemake/payBill', JSON.stringify({
            data: billingDatas[index]
        }));
    });

    function addCommas(inputText) {
        // pattern works from right to left
        var commaPattern = /(\d+)(\d{3})(\.\d*)*$/;
        var callback = function (match, p1, p2, p3) {
            return p1.replace(commaPattern, callback) + '.' + p2 + (p3 || '');
        };
        return inputText.replace(commaPattern, callback);
    }

    function AddTransaction(data) {
        var classs = "";
        if (darkMode) {
            classs = "darkness"
        }
        $("#islemler").html($.parseHTML(('<div class="islem '+classs+'"><div class="islemIconHolder"><i class="'+ data.icon + '" aria-hidden="true"></i></div><div class="islemBilgiHolder"><p class="islemTuruText '+classs+'">'+ data.status +'<a class="gonderenGonderilenBilgi '+classs+'">'+data.comingFrom+'</a></p><span class="'+data.color+'">'+ data.amount +'</span><span class="islemZaman '+classs+'">'+ data.time +'</span></div></div>') + $("#islemler").html()))
        if (darkMode) {

        }
    }
    
    function AddBill(data) {
        data['editedAmount'] = '$'+(addCommas(String(data.amount))) + ',00'
        billingDatas.push(data)
        $(".faturalar").html($.parseHTML((('<div class="fatura"><span class="faturaTarih">' + data.time + '</span><button type="button" class="faturaOdeButton">Pay</button><input type="hidden" name="index" value="'+String(billingDatas.length - 1)+'"><p class="faturaGonderenIsım">' + data.senderFullName + '</p><span class="faturaAciklama">' + data.label + '</span><span class="faturaDurum">Waiting</span><span class="faturaUcret">$'+(addCommas(String(data.amount))) + ',00</span></div>')) + $(".faturalar").html()))
    }

    function GetDateAndTime() {
        
        var tarih = new Date();
        return anlik = (("0" + tarih.getDate()).slice(-2) + "-" + ("0" + (tarih.getMonth()+1)).slice(-2)  + "-" + tarih.getFullYear() + " " + ("0" + tarih.getHours()).slice(-2) + ":" + ("0" + tarih.getMinutes()).slice(-2))
    }

    function BasarisizIslemGoster() {
        $(".dark").css({ "display":"block"})
        $("#basarili").html("<i class=\"fal fa-times-circle\"></i><br><p class=\"basariliText\"></p>")
        $(".basariliText").text("İşlem gerçekleştirilemedi.")
        setTimeout(function(){jQuery('.dark').fadeIn(1000)}, 500);
        setTimeout(function(){jQuery('.dark').fadeOut(1000)}, 3000);
        $(".dark").css({ "display":"none"})
    }

    function clearTheUI() {
        $("#islemler").html("")
        $(".faturalar").html("")
    }

    function setupNameAmountAndIBAN(data) {
        $(".playerName").html(data.fullName)
        $("#playerMoneyAmount").html(addCommas((String(data.currentMoney))))
        $("#playerMoneyAmount").append(",00")
        $("#playerMoneyAmount").prepend("$")
        $(".playerIBAN").html(data.IBAN)
    }

    function ShowMessage(icon, message) {
        $(".dark").css({ "display":"block"})
        $("#basarili").html('<i class="'+icon+'"></i><br><p class="basariliText">'+message+'</p>')
        setTimeout(function(){jQuery('.dark').fadeIn(1000)}, 500);
        setTimeout(function(){jQuery('.dark').fadeOut(1000)}, 3000);
        $(".dark").css({ "display":"none"})
    }

});