document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('enterBtn').addEventListener('click', function() {
        let input1 = document.getElementById('input1').value;
        let input2 = document.getElementById('input2').value;
        window.location.href = 'skp:getInputs@' + encodeURIComponent(input1 + ',' + input2);
    });

    document.getElementById('getDcAttributesBtn').addEventListener('click', function() {
        window.location.href = 'skp:getDcAttributes@';
    });
});

function updateDcAttributesDisplay(data) {
    document.getElementById('dcAttributesContent').textContent = data;
}