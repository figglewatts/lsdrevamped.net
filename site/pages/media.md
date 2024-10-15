---
layout: page
---

## Media

<div class="d-flex flex-wrap">
    {{- range (.Conf.Get "media").Array }}
    <a href="./img/{{ . }}.png" target="_blank" class="w-100 my-2"><img class="img-fluid" src="./img/{{ . }}.png"/></a>
    {{- end }}
</div>
