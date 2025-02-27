"use strict";
var isWeb;
var teXView;

function initTeXView(jsonData) {
    isWeb = false;
    teXView.innerHTML = '';
    teXView.appendChild(createTeXView(jsonData));
    renderTeXView(renderCompleted);
}

function initWebTeXView(viewId, rawData) {
    isWeb = true
    var initiated = false;
    document.querySelectorAll("flt-platform-view").forEach(function (platformView) {
        var view = platformView.shadowRoot.children[1];
        if (view.id === viewId) {
            var iframe = view.contentWindow;
            if (iframe != null) {
                teXView = iframe.document.getElementById('TeXView');
                if (teXView != null) {
                    initiated = true;
                    var jsonData = JSON.parse(rawData);
                    teXView.innerHTML = '';
                    teXView.appendChild(createTeXView(jsonData));
                    iframe.renderTeXView(renderCompleted);
                }
            }
        }
    }
    );
    if (!initiated) setTimeout(function () {
        initWebTeXView(viewId, rawData)
    }, 250);
}


function createTeXView(rootData) {
    var meta = rootData['meta'];
    var data = rootData['data'];
    var id = meta['id']
    var classList = meta['classList'];
    var element = document.createElement(meta['tag']);
    element.className = classList;
    element.setAttribute('style', rootData['style']);
    element.setAttribute('id', id)
    switch (meta['node']) {
        case 'leaf': {
            if (meta['tag'] === 'img') {
                if (classList === 'tex-view-asset-image') {
                    element.setAttribute('src', getAssetsUri() + data);
                } else {
                    element.setAttribute('src', data);
                    element.addEventListener("load", renderCompleted);
                }
            } else {
                element.innerHTML = data;
            }
        }
            break;
        case 'internal_child': {
            element.appendChild(createTeXView(data))
            if (classList === 'tex-view-ink-well') clickManager(element, id, rootData['rippleEffect']);
        }
            break;
        case 'root':
            rootData['fonts'].forEach(function (font) {
                registerFont(font['font_family'], font['src'])
            })
            element.appendChild(createTeXView(data));
            break;
        default: {
            if (classList === 'tex-view-group') {
                createTeXViewGroup(element, rootData);
            }
            else if (classList === 'tex-view-group-radio') {
                createTeXViewGroupRadio(element, rootData);
            }
            else {
                data.forEach(function (childViewData) {
                    element.appendChild(createTeXView(childViewData))
                });
            }
        }
    }
    return element;
}

function createTeXViewGroup(element, rootData) {

    var normalStyle = rootData['normalItemStyle'];
    var selectedStyle = rootData['selectedItemStyle'];
    var single = rootData['single'];
    var lastSelected;
    var selectedIds = [];


    rootData['data'].forEach(function (data) {
        data['style'] = normalStyle;
        var item = createTeXView(data);
        var id = data['meta']['id'];
        item.setAttribute('id', id);

        clickManager(item, id, rootData['rippleEffect'], function (clickedId) {
            if (clickedId === id) {
                if (single) {
                    if (lastSelected != null) {
                        lastSelected.setAttribute('style', normalStyle);
                        lastSelected.classList.remove('selected');
                    }
                    item.setAttribute('style', selectedStyle);
                    item.classList.add('selected');
                    lastSelected = item;
                    onTapCallback(clickedId);
                } else {
                    if (arrayContains(selectedIds, clickedId)) {
                        document.getElementById(clickedId).setAttribute('style', normalStyle);
                        document.getElementById(clickedId).classList.remove('selected');
                        selectedIds.splice(selectedIds.indexOf(clickedId), 1)
                    } else {
                        document.getElementById(clickedId).setAttribute('style', selectedStyle);
                        document.getElementById(clickedId).classList.add('selected');
                        selectedIds.push(clickedId);
                    }
                    onTapCallback(JSON.stringify(selectedIds));
                }
            }
            renderCompleted();
        })
        element.appendChild(item);
    });
}

function createTeXViewGroupRadio(element, rootData) {
    var normalStyle = rootData['normalItemStyle'];
    var selectedStyle = rootData['selectedItemStyle'];
    var lastSelected;

    rootData['data'].forEach(function (data) {
        data['style'] = normalStyle;
        var item = createTeXView(data);
        var id = data['meta']['id'];
        item.setAttribute('id', id);
        if (data['meta']['classList'].includes("selected"))
            lastSelected = item;

        clickManager(item, id, rootData['rippleEffect'], function (clickedId) {
            if (clickedId === id) {
                if (lastSelected === item) {
                    lastSelected.setAttribute('style', normalStyle);
                    lastSelected.classList.remove('selected');
                    lastSelected = null;
                    onTapCallback(clickedId);
                }
                else {
                    if (lastSelected != null) {
                        lastSelected.setAttribute('style', normalStyle);
                        lastSelected.classList.remove('selected');
                    }
                    item.setAttribute('style', selectedStyle);
                    item.classList.add('selected');
                    lastSelected = item;
                    onTapCallback(clickedId);
                }
            }
            renderCompleted();
        });
        element.appendChild(item);
    });
}

function arrayContains(array, obj) {
    var i = array.length;
    while (i--) {
        if (array[i] === obj) {
            return true;
        }
    }
    return false;
}

function renderCompleted() {
    if (isWeb) {
        // noinspection JSUnresolvedFunction
        TeXViewRenderedCallback(getTeXViewHeight());
    } else {
        // noinspection JSUnresolvedVariable
        TeXViewRenderedCallback.postMessage(getTeXViewHeight());
    }
}

function clickManager(element, id, rippleEffect, callback) {
    element.addEventListener('click', function (e) {
        if (callback != null) {
            callback(id);
        } else {
            onTapCallback(id);
        }

        if (rippleEffect) {
            var ripple = document.createElement('div');
            this.appendChild(ripple);
            var d = Math.max(this.clientWidth, this.clientHeight);
            ripple.style.width = ripple.style.height = d + 'px';
            var rect = this.getBoundingClientRect();
            ripple.style.left = e.clientX - rect.left - d / 2 + 'px';
            ripple.style.top = e.clientY - rect.top - d / 2 + 'px';
            ripple.classList.add('ripple');
        }
    });
}


function onTapCallback(message) {
    if (isWeb) {
        // noinspection JSUnresolvedFunction
        OnTapCallback(message);
    } else {
        // noinspection JSUnresolvedVariable
        OnTapCallback.postMessage(message);
    }
}


function getTeXViewHeight() {
    var element = teXView;
    var height = element.offsetHeight,
        style = window.getComputedStyle(element)
    return ['top', 'bottom']
        .map(function (side) {
            return parseInt(style["margin-" + side]);
        })
        .reduce(function (total, side) {
            return total + side;
        }, height) + 2;
}

function registerFont(fontFamily, src) {
    var registerFont =
        ' @font-face {                               \n' +
        '   font-family: ' + fontFamily + ';         \n' +
        '   src: url(' + getAssetsUri() + src + ');  \n' +
        ' }';
    appendStyle(registerFont);
}

function getAssetsUri() {
    var currentUrl = location.protocol + '//' + location.host;
    var uri;
    if (isWeb) {
        uri = currentUrl + '/assets/';
    } else {
        uri = currentUrl + '/';
    }
    return uri
}

function appendStyle(content) {
    var style = document.createElement('STYLE');
    style.type = 'text/css';
    style.appendChild(document.createTextNode(content));
    document.head.appendChild(style);
}
