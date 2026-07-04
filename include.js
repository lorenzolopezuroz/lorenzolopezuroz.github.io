async function loadHTML(elementId, filePath) {
    const response = await fetch(filePath);

    if (!response.ok) {
        throw new Error(`Failed to lead ${filePath}: ${response.statusText}`);
        return;
    }

    const html = await response.text(); 

    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = html;
    } else {
        throw new Error(`Element with ID "${elementId}" not found`);
    }
    element.innerHTML = html;
}

document.addEventListener('DOMContentLoaded', () => {
    loadHTML('header', 'header.html');
});