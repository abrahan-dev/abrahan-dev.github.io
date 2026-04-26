(function () {
  function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    }

    var textarea = document.createElement("textarea");
    textarea.value = text;
    textarea.setAttribute("readonly", "");
    textarea.style.position = "fixed";
    textarea.style.top = "-9999px";
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand("copy");
    document.body.removeChild(textarea);
    return Promise.resolve();
  }

  document.querySelectorAll(".content div.highlighter-rouge").forEach(function (block, index) {
    if (block.classList.contains("code-block-ready")) return;

    var code = block.querySelector("code");
    var highlight = block.querySelector(".highlight");
    if (!code || !highlight) return;
    var rawCode = code.innerText;

    block.classList.add("code-block", "code-block-ready");

    var languageClass = Array.from(block.classList).find(function (className) {
      return className.indexOf("language-") === 0;
    });
    var language = languageClass ? languageClass.replace("language-", "") : "code";

    var header = document.createElement("div");
    header.className = "code-block-header";

    var label = document.createElement("span");
    label.className = "code-block-language";
    label.textContent = language;

    var button = document.createElement("button");
    button.className = "code-copy-button";
    button.type = "button";
    button.textContent = "Copy";
    button.setAttribute("aria-label", "Copy code block " + (index + 1));

    header.appendChild(label);
    header.appendChild(button);
    block.insertBefore(header, block.firstChild);

    var body = document.createElement("div");
    body.className = "code-block-body";

    var gutter = document.createElement("div");
    gutter.className = "code-line-numbers";
    rawCode
      .replace(/\n$/, "")
      .split("\n")
      .forEach(function (_line, lineIndex) {
        var number = document.createElement("span");
        number.textContent = String(lineIndex + 1);
        gutter.appendChild(number);
      });

    block.insertBefore(body, highlight);
    body.appendChild(gutter);
    body.appendChild(highlight);

    button.addEventListener("click", function () {
      copyText(rawCode).then(function () {
        button.textContent = "Copied";
        window.setTimeout(function () {
          button.textContent = "Copy";
        }, 1400);
      });
    });
  });
})();
