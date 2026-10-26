/* DADOS (espelham os INSERTs do script SQL).
   Para ligar ao MySQL real, troque esta constante por fetch('/api/...') (veja README). */
const DB = {
  cliente:[[1,'Carlos Silva','111.222.333-44','(11) 98765-4321','carlos@email.com'],[2,'Ana Maria Souza','222.333.444-55','(11) 97654-3210','ana.souza@email.com'],[3,'Empresa Logística LTDA','12.345.678/0001-99','(11) 3333-4444','contato@logistica.com'],[4,'Roberto Santos','444.555.666-77','(21) 99887-6655','roberto@email.com'],[5,'Mariana Lima','555.666.777-88','(31) 98877-1122','mariana@email.com']],
  vendedor:[[1,'João Pereira','123.456.789-01',2.5],[2,'Beatriz Costa','234.567.890-12',3],[3,'Fernando Oliveira','345.678.901-23',2.5],[4,'Patricia Rocha','456.789.012-34',2.8],[5,'Lucas Mendes','567.890.123-45',3]],
  veiculo:[[1,'9BWZZZ377VT001001','Onix','Chevrolet',2023,75000,'Vendido'],[2,'9BWZZZ377VT001002','Corolla','Toyota',2024,150000,'Vendido'],[3,'9BWZZZ377VT001003','Civic','Honda',2022,130000,'Vendido'],[4,'9BWZZZ377VT001004','Compass','Jeep',2024,180000,'Vendido'],[5,'9BWZZZ377VT001005','HB20','Hyundai',2023,70000,'Vendido'],[6,'9BWZZZ377VT001006','Renegade','Jeep',2024,125000,'Disponível']],
  venda:[[1,'2026-01-15',75000,1,1,1],[2,'2026-01-20',150000,2,2,2],[3,'2026-02-10',130000,3,1,3],[4,'2026-02-15',180000,4,3,4],[5,'2026-03-01',70000,5,4,5]],
  servico:[[1,'Troca de Óleo e Filtro',250],[2,'Alinhamento e Balanceamento',180],[3,'Revisão de Freios',350],[4,'Higienização de Ar Condicionado',150],[5,'Troca de Correia Dentada',600]],
  ordem_servico:[[1,'2026-03-10','Revisão periódica de 10.000km',430,1,1],[2,'2026-03-12','Barulho ao frear e direção puxando',530,2,2],[3,'2026-03-15','Troca de óleo preventiva',250,3,3],[4,'2026-03-20','Ar condicionado com mau cheiro',150,4,4],[5,'2026-03-22','Revisão geral e troca de correia',950,5,5]],
  item_os:[[1,1,1,250],[1,2,1,180],[2,2,1,180],[2,3,1,350],[3,1,1,250],[4,4,1,150],[5,3,1,350],[5,5,1,600]]
};
const COLS = {
  cliente:['ID','Nome','CPF/CNPJ','Telefone','E-mail'],
  vendedor:['ID','Nome','CPF','Comissão (%)'],
  veiculo:['ID','Chassi','Modelo','Marca','Ano','Preço','Status'],
  venda:['ID','Data','Valor total','Cliente','Vendedor','Veículo'],
  servico:['ID','Serviço','Preço de tabela'],
  ordem_servico:['ID','Abertura','Problema','Valor total','Veículo','Cliente'],
  item_os:['OS','Serviço','Qtd.','Preço praticado']
};
const NAMES = {cliente:'Clientes',vendedor:'Vendedores',veiculo:'Veículos',venda:'Vendas',servico:'Serviços',ordem_servico:'Ordens de serviço',item_os:'Itens da OS'};

const brl = n => n.toLocaleString('pt-BR',{style:'currency',currency:'BRL'});
const dt = s => s.split('-').reverse().join('/');
const by = (t,i)=>DB[t].find(r=>r[0]===i);
const sum = a => a.reduce((x,y)=>x+y,0);
const MONEY = new Set(['Preço','Valor total','Preço de tabela','Preço praticado','Faturamento','Comissão a receber','Valor','Faturamento total','Média das OS']);

/* Render genérico */
function render(el, cols, rows){
  el.innerHTML = '<thead><tr>'+cols.map(c=>`<th>${c}</th>`).join('')+'</tr></thead><tbody>'+
    (rows.length ? rows.map(r=>'<tr>'+r.map((v,i)=>{
      const c = cols[i];
      if(c==='Status') return `<td><span class="tag ${v==='Vendido'?'off':''}">${v}</span></td>`;
      if(MONEY.has(c) && typeof v==='number') return `<td class="num">${brl(v)}</td>`;
      if((c==='Data'||c==='Abertura') && /^\d{4}-/.test(v)) return `<td>${dt(v)}</td>`;
      return `<td${typeof v==='number'?' class="num"':''}>${v}</td>`;
    }).join('')+'</tr>').join('') : `<tr><td colspan="${cols.length}">Nenhum resultado.</td></tr>`)+'</tbody>';
}

/* Estatísticas */
const faturamento = sum(DB.venda.map(v=>v[2]));
document.getElementById('stats').innerHTML = [
  [DB.veiculo.length,'veículos cadastrados'],
  [DB.veiculo.filter(v=>v[6]==='Disponível').length,'disponível para venda'],
  [DB.venda.length,'vendas realizadas'],
  [brl(faturamento),'faturamento total']
].map(s=>`<div class="stat"><b>${s[0]}</b><span>${s[1]}</span></div>`).join('');

/* Abas das tabelas */
const tabs = document.getElementById('tabs'), tbl = document.getElementById('tbl');
function showTable(k){
  [...tabs.children].forEach(b=>b.setAttribute('aria-pressed', b.dataset.k===k));
  render(tbl, COLS[k], DB[k]);
}
Object.keys(DB).forEach(k=>{
  const b=document.createElement('button');
  b.textContent=NAMES[k]; b.dataset.k=k; b.onclick=()=>showTable(k);
  tabs.appendChild(b);
});
showTable('cliente');

/* Consultas */
const vendaFull = DB.venda.map(v=>({id:v[0],data:v[1],total:v[2],cli:by('cliente',v[3]),vd:by('vendedor',v[4]),vei:by('veiculo',v[5])}));
const porVend = () => { const m={}; vendaFull.forEach(v=>{(m[v.vd[1]]??={n:0,t:0}); m[v.vd[1]].n++; m[v.vd[1]].t+=v.total}); return Object.entries(m); };
const osFull = DB.ordem_servico.map(o=>({id:o[0],data:o[1],desc:o[2],total:o[3],vei:by('veiculo',o[4]),cli:by('cliente',o[5])}));
const QUERIES = [
 {t:'1. Vendas com cliente, vendedor e veículo',s:'INNER JOIN entre venda, cliente, vendedor e veiculo',
  c:['ID','Data','Cliente','Vendedor','Modelo','Valor total'],r:()=>vendaFull.map(v=>[v.id,v.data,v.cli[1],v.vd[1],v.vei[2],v.total])},
 {t:'2. Veículos disponíveis ou abaixo de R$ 130.000',s:"WHERE status = 'Disponível' OR preco < 130000",
  c:['Marca','Modelo','Ano','Preço'],r:()=>DB.veiculo.filter(v=>v[6]==='Disponível'||v[5]<130000).map(v=>[v[3],v[2],v[4],v[5]])},
 {t:'3. Clientes com "Silva" ou "Souza"',s:"WHERE nome LIKE '%Silva%' OR nome LIKE '%Souza%'",
  c:COLS.cliente,r:()=>DB.cliente.filter(c=>/Silva|Souza/.test(c[1]))},
 {t:'4. Vendas e faturamento por vendedor',s:'GROUP BY vendedor, COUNT e SUM',
  c:['Vendedor','Total de vendas','Faturamento'],r:()=>porVend().map(([n,x])=>[n,x.n,x.t])},
 {t:'5. Vendas do primeiro bimestre de 2026',s:"WHERE data_venda BETWEEN '2026-01-01' AND '2026-02-28'",
  c:['ID','Data','Valor total'],r:()=>vendaFull.filter(v=>v.data>='2026-01-01'&&v.data<='2026-02-28').sort((a,b)=>a.data.localeCompare(b.data)).map(v=>[v.id,v.data,v.total])},
 {t:'6. Comissão a pagar por venda',s:'valor_total * comissao_percentual / 100',
  c:['ID','Vendedor','Valor total','Comissão a receber'],r:()=>vendaFull.map(v=>[v.id,v.vd[1],v.total,Math.round(v.total*v.vd[3])/100])},
 {t:'7. Média do valor das ordens de serviço',s:'AVG(valor_total)',
  c:['Média das OS'],r:()=>[[Math.round(sum(osFull.map(o=>o.total))/osFull.length*100)/100]]},
 {t:'8. Ordens de serviço pelo maior valor',s:'ORDER BY valor_total DESC',
  c:['OS','Cliente','Modelo','Valor total'],r:()=>[...osFull].sort((a,b)=>b.total-a.total).map(o=>[o.id,o.cli[1],o.vei[2],o.total])},
 {t:'9. Veículos com histórico de ordem de serviço',s:'INNER JOIN ordem_servico e veiculo',
  c:['Modelo','Chassi','Abertura','Problema'],r:()=>osFull.map(o=>[o.vei[2],o.vei[1],o.data,o.desc])},
 {t:'10. Vendedores com faturamento acima de R$ 100.000',s:'GROUP BY vendedor HAVING SUM(valor_total) > 100000',
  c:['Vendedor','Faturamento total'],r:()=>porVend().filter(([,x])=>x.t>100000).map(([n,x])=>[n,x.t])},
 {t:'11. Serviços executados acima de R$ 200',s:'DISTINCT serviço com preco_tabela > 200 em item_os',
  c:['Serviço','Preço de tabela'],r:()=>DB.servico.filter(s=>s[2]>200&&DB.item_os.some(i=>i[1]===s[0])).map(s=>[s[1],s[2]])},
 {t:'12. Veículos por marca',s:'GROUP BY marca, COUNT(*)',
  c:['Marca','Quantidade'],r:()=>{const m={};DB.veiculo.forEach(v=>m[v[3]]=(m[v[3]]||0)+1);return Object.entries(m)}},
 {t:'13. Itens da ordem de serviço 5',s:'WHERE id_os = 5',
  c:['OS','Serviço','Qtd.','Preço praticado'],r:()=>DB.item_os.filter(i=>i[0]===5).map(i=>[i[0],by('servico',i[1])[1],i[2],i[3]])},
 {t:'14. Clientes sem ordem de serviço',s:'LEFT JOIN ordem_servico WHERE id_os IS NULL',
  c:['Nome','Telefone','E-mail'],r:()=>DB.cliente.filter(c=>!DB.ordem_servico.some(o=>o[5]===c[0])).map(c=>[c[1],c[3],c[4]])},
 {t:'15. Veículo mais caro',s:'WHERE preco = (SELECT MAX(preco) FROM veiculo)',
  c:['Marca','Modelo','Ano','Preço'],r:()=>{const m=Math.max(...DB.veiculo.map(v=>v[5]));return DB.veiculo.filter(v=>v[5]===m).map(v=>[v[3],v[2],v[4],v[5]])}}
];
const sel=document.getElementById('q');
QUERIES.forEach((q,i)=>sel.add(new Option(q.t,i)));
function runQuery(){
  const q=QUERIES[sel.value];
  document.getElementById('qsql').textContent=q.s;
  render(document.getElementById('qtbl'),q.c,q.r());
}
sel.onchange=runQuery; runQuery();
