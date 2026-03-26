document.querySelector('.input').addEventListener('change', function() {
    const label = this.closest('.new_input');
    const fileName = this.files[0]?.name || 'Выбрать файл';
    label.childNodes[label.childNodes.length - 1].textContent = ' ' + fileName;
    label.classList.add('selected'); // меняем цвет
});