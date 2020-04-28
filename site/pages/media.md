---
layout: page
---

## Media

<div class="d-flex flex-wrap">
    {{- range (.Conf.Get "media").Array }}
    <a href="./img/game/{{ . }}.png" target="_blank" class="w-100 my-2"><img class="img-fluid" src="./img/game/{{ . }}-thumb.png"/></a>
    {{- end }}
</div>