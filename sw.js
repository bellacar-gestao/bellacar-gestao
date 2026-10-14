// Service Worker BellaCar PWA - v3 Ultra Fast & Network First
const CACHE_NAME = 'bellacar-cache-v3-speed';
const STATIC_ASSETS = ['./', './manifest.json', './logo.png'];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(STATIC_ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
    ))
  );
  self.clients.claim();
});

// Network-First para index.html (garante sempre a versão mais recente em tempo real)
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  if (event.request.mode === 'navigate' || url.pathname.endsWith('index.html') || url.pathname.endsWith('/')) {
    event.respondWith(
      fetch(event.request)
        .then(response => {
          if (response && response.status === 200) {
            const clone = response.clone();
            caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
          }
          return response;
        })
        .catch(() => caches.match(event.request))
    );
    return;
  }

  // Cache-First com fallback de rede para imagens e ícones estáticos
  event.respondWith(
    caches.match(event.request).then(cached => cached || fetch(event.request))
  );
});
