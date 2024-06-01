export function measureTextSize(text: string, font: string) {
  // Create a temporary span element
  const element = document.createElement("span");
  // Set the font style (the same way you define it in CSS)
  element.style.font = font;
  // Ensure the element does not affect layout
  element.style.position = "absolute";
  element.style.whiteSpace = "nowrap";
  element.style.visibility = "hidden";
  // Set the text content
  element.textContent = text;
  // Append to the body to make measurements
  document.body.appendChild(element);
  // Measure the text width
  const { width, height } = element.getBoundingClientRect();
  // Remove the element from the DOM
  document.body.removeChild(element);
  return { width, height };
}
