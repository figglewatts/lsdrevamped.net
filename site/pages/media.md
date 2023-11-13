---
layout: page
---

## Media

<div class="d-flex flex-wrap">
    {{- range (.Conf.Get "media").Array }}
    <a href="./img/0.2/{{ . }}.png" target="_blank" class="w-100 my-2"><img class="img-fluid" src="./img/0.2/{{ . }}.png"/></a>
    {{- end }}
</div>
