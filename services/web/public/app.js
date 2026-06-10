const productsEl = document.getElementById('products');
const cartItemsEl = document.getElementById('cart-items');
const cartTotalEl = document.getElementById('cart-total');
const checkoutBtn = document.getElementById('checkout');
const refreshBtn = document.getElementById('refresh');
const checkoutResult = document.getElementById('checkout-result');

let products = [];
let cart = [];

function renderProducts() {
  productsEl.innerHTML = '';
  products.forEach(p => {
    const div = document.createElement('div');
    div.className = 'product';
    div.innerHTML = `
      <strong>${p.name}</strong>
      <div>Price: $${p.price.toFixed(2)}</div>
      <button data-id="${p.id}" class="add">Add to cart</button>
    `;
    productsEl.appendChild(div);
  });
}

function renderCart() {
  cartItemsEl.innerHTML = '';
  let total = 0;
  cart.forEach(item => {
    const li = document.createElement('li');
    li.textContent = `${item.name} x ${item.qty} - $${(item.qty * item.price).toFixed(2)}`;
    cartItemsEl.appendChild(li);
    total += item.qty * item.price;
  });
  cartTotalEl.textContent = total.toFixed(2);
}

async function loadProducts() {
  try {
    const res = await fetch('/api/products');
    products = await res.json();
  } catch (err) {
    products = [];
  }
  renderProducts();
}

function addToCart(id) {
  const p = products.find(x => x.id === id);
  if (!p) return;
  const existing = cart.find(x => x.id === id);
  if (existing) existing.qty += 1;
  else cart.push({ id: p.id, name: p.name, price: p.price, qty: 1 });
  renderCart();
}

productsEl.addEventListener('click', (e) => {
  if (e.target.matches('button.add')) {
    const id = Number(e.target.dataset.id);
    addToCart(id);
  }
});

refreshBtn.addEventListener('click', () => loadProducts());

checkoutBtn.addEventListener('click', async () => {
  if (cart.length === 0) return;
  checkoutBtn.disabled = true;
  checkoutResult.textContent = 'Processing...';
  try {
    const res = await fetch('/api/checkout', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ cart }) });
    const data = await res.json();
    checkoutResult.textContent = data.order_id ? `Order placed: ${data.order_id}` : JSON.stringify(data);
    cart = [];
    renderCart();
  } catch (err) {
    checkoutResult.textContent = 'Checkout failed';
  }
  checkoutBtn.disabled = false;
});

loadProducts();
