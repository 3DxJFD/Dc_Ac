document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('submitBtn').addEventListener('click', function() {
        let input1 = document.getElementById('input1').value;
        let input2 = document.getElementById('input2').value;
        window.location.href = 'skp:handleSubmit@' + encodeURIComponent(input1 + ',' + input2);
    });
});

function updateAttributes(data) {
    document.getElementById('attributesContent').textContent = data;
}