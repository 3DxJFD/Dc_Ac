document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('enterBtn').addEventListener('click', function() {
        let input1 = document.getElementById('input1').value;
        let input2 = document.getElementById('input2').value;
        console.log("Enter button clicked: ", input1, input2);
        window.location.href = 'skp:getInputs@' + encodeURIComponent(input1 + ',' + input2);
    });
});

function updateDcAttributesDisplay(data) {
    document.getElementById('dcAttributesContent').innerHTML = data;
}

function clearDcAttributesDisplay() {
    document.getElementById('dcAttributesContent').innerHTML = "No Dynamic Component selected.";
}