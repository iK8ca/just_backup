<div>
<div>
<input name='x'>
</div>
<div>
<div>Item1</div>
<div>Item2</div>
<div>Item3</div>
<div>Item4</div>
</div>
</div>

// 点击 input name=x 的下拉框中的Item1
let name = 'x'
let value = 'Item1'
let result = await this.page.evaluate((name, value) => {
let result = -1
let list = document.querySelector('[name=' + name + ']').parentElement.parentElement.children[1].children)
for (let i = 0; i < list.length; i++) {
let c = list[i]
c.id = '_select_' + name + '_' + i
if (c.innerText === value) { // found ?
result = i
}
}
return result
}, name, value)
if (result == -1) {
throw new Error(value + ' not found!!')
}
await this.page.click('#_select_x_' + result)