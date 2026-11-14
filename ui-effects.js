/* Raasta immersive UI layer — isolated from routing and application logic. */
(() => {
  const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const hero = document.querySelector('.hero');
  const art = document.querySelector('.hero-art');

  // Theme switch: user preference is persisted locally; routing/API code is untouched.
  const themeToggle = document.getElementById('theme-toggle');
  const themeKey = 'raasta-theme';
  function applyTheme(theme) {
    const dark = theme === 'dark';
    document.documentElement.dataset.theme = dark ? 'dark' : 'light';
    if (themeToggle) {
      themeToggle.setAttribute('aria-pressed', String(dark));
      themeToggle.setAttribute('aria-label', dark ? 'Switch to light mode' : 'Switch to dark mode');
      const icon = themeToggle.querySelector('.theme-toggle-icon');
      const label = themeToggle.querySelector('.theme-toggle-label');
      if (icon) icon.textContent = dark ? '☀' : '☾';
      if (label) label.textContent = dark ? 'LIGHT' : 'DARK';
    }
    try { localStorage.setItem(themeKey, dark ? 'dark' : 'light'); } catch (_) {}
  }
  let savedTheme = 'light';
  try { savedTheme = localStorage.getItem(themeKey) || 'light'; } catch (_) {}
  applyTheme(savedTheme);
  if (themeToggle) themeToggle.addEventListener('click', () => {
    applyTheme(document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark');
  });




  // Tactile press feedback for every enabled button; existing app.js click
  // handlers remain responsible for navigation, routing and admin actions.
  document.addEventListener('pointerdown', event => {
    const button = event.target.closest('button');
    if (!button || button.disabled) return;
    button.classList.add('clay-pressed');
  }, {passive:true});
  const clearPressed = () => document.querySelectorAll('.clay-pressed').forEach(button => button.classList.remove('clay-pressed'));
  document.addEventListener('pointerup', clearPressed, {passive:true});
  document.addEventListener('pointercancel', clearPressed, {passive:true});
  document.addEventListener('focusout', event => event.target.classList?.remove('clay-pressed'));

  // Reveal sections as they enter the viewport.
  const revealTargets = [
    '.intro-section .section-index', '.intro-main', '.principle-strip > div',
    '.preview-copy', '.preview-map', '.honesty-band',
    '.planner-heading', '.journey-panel', '.map-column', '.results-panel',
    '.network-controls', '.network-list-panel', '.network-detail',
    '.admin-alert', '.admin-login', '.admin-workspace'
  ];
  revealTargets.forEach(selector => document.querySelectorAll(selector).forEach((node, i) => {
    node.classList.add('raasta-reveal');
    node.style.setProperty('--reveal-delay', `${Math.min(i, 4) * 75}ms`);
  }));

  let revealObserver = null;
  if (reduceMotion || !('IntersectionObserver' in window)) {
    document.querySelectorAll('.raasta-reveal').forEach(n => n.classList.add('is-visible'));
  } else {
    revealObserver = new IntersectionObserver(entries => entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        revealObserver.unobserve(entry.target);
      }
    }), { threshold: 0.12, rootMargin: '0px 0px -42px 0px' });
    document.querySelectorAll('.raasta-reveal').forEach(n => revealObserver.observe(n));

    // Results and station rows are created by the existing app at runtime.
    // Observe their appearance without touching their data or event handlers.
    const dynamicObserver = new MutationObserver(records => records.forEach(record =>
      record.addedNodes.forEach(node => {
        if (!(node instanceof HTMLElement)) return;
        const candidates = [];
        if (node.matches?.('.route-card,.station-row,.admin-stat')) candidates.push(node);
        candidates.push(...(node.querySelectorAll?.('.route-card,.station-row,.admin-stat') || []));
        candidates.forEach((item, index) => {
          if (item.classList.contains('raasta-reveal')) return;
          item.classList.add('raasta-reveal');
          item.style.setProperty('--reveal-delay', `${Math.min(index, 4) * 55}ms`);
          revealObserver.observe(item);
        });
      })
    ));
    ['route-list','network-stations','admin-stats','admin-table','connection-table'].forEach(id => {
      const target = document.getElementById(id);
      if (target) dynamicObserver.observe(target, { childList: true, subtree: true });
    });
  }


  // Real-world 3D city layer. Uses OpenStreetMap building footprints and roads
  // through OpenFreeMap vector tiles; decorative only, independent of routing.
  function startRealCity() {
    if (!hero || !art || !window.maplibregl || art.dataset.cityReady === '1') return;
    art.dataset.cityReady = '1';
    art.innerHTML = '';
    art.classList.add('real-city-art');

    const map = new maplibregl.Map({
      container: art,
      style: 'https://tiles.openfreemap.org/styles/positron',
      center: [77.2090, 28.6139],
      zoom: 14.25,
      pitch: 62,
      bearing: -24,
      antialias: true,
      attributionControl: false,
      cooperativeGestures: true
    });

    map.addControl(new maplibregl.NavigationControl({showCompass:true, showZoom:false}), 'bottom-right');
    map.addControl(new maplibregl.AttributionControl({compact:true}), 'bottom-left');
    map.scrollZoom.disable();
    map.doubleClickZoom.disable();

    map.on('load', () => {
      const layers = map.getStyle().layers || [];
      const labelLayer = layers.find(layer => layer.type === 'symbol' && layer.layout && layer.layout['text-field']);
      const beforeId = labelLayer ? labelLayer.id : undefined;

      // OpenMapTiles building footprints are real mapped footprints, not generated boxes.
      if (map.getSource('openmaptiles') && !map.getLayer('raasta-3d-buildings')) {
        map.addLayer({
          id: 'raasta-3d-buildings',
          source: 'openmaptiles',
          'source-layer': 'building',
          type: 'fill-extrusion',
          minzoom: 13,
          paint: {
            'fill-extrusion-color': [
              'interpolate', ['linear'], ['coalesce', ['to-number', ['get', 'render_height']], 12],
              0, '#d7d2c8', 35, '#c4c0b6', 90, '#aaa79f', 180, '#8e9692'
            ],
            'fill-extrusion-height': [
              'interpolate', ['linear'], ['zoom'],
              13, 0,
              15, ['coalesce', ['to-number', ['get', 'render_height']], ['*', ['to-number', ['get', 'building:levels']], 3.2], 10]
            ],
            'fill-extrusion-base': ['coalesce', ['to-number', ['get', 'render_min_height']], 0],
            'fill-extrusion-opacity': 0.94,
            'fill-extrusion-vertical-gradient': true
          }
        }, beforeId);
      }

      // A restrained transit-orientation marker at Connaught Place.
      if (!map.getSource('raasta-hub')) {
        map.addSource('raasta-hub', {
          type: 'geojson',
          data: {
            type: 'FeatureCollection',
            features: [{
              type: 'Feature',
              properties: {name: 'Connaught Place'},
              geometry: {type: 'Point', coordinates: [77.2195, 28.6315]}
            }]
          }
        });
        map.addLayer({
          id: 'raasta-hub-glow',
          type: 'circle',
          source: 'raasta-hub',
          paint: {
            'circle-radius': 13,
            'circle-color': '#c84b32',
            'circle-opacity': 0.18,
            'circle-blur': 0.65
          }
        });
        map.addLayer({
          id: 'raasta-hub-point',
          type: 'circle',
          source: 'raasta-hub',
          paint: {
            'circle-radius': 4,
            'circle-color': '#c84b32',
            'circle-stroke-width': 1.5,
            'circle-stroke-color': '#fffaf1'
          }
        });
      }
      art.classList.add('real-city-loaded');
      requestAnimationFrame(() => map.resize());
    });

    map.on('error', event => {
      if (event && event.error) console.warn('Raasta 3D map:', event.error.message || event.error);
    });

    // Slight camera drift, paused when the hero leaves the viewport.
    let driftFrame = 0;
    let active = true;
    const observer = new IntersectionObserver(entries => {
      active = entries[0].isIntersecting;
      if (active) drift();
      else cancelAnimationFrame(driftFrame);
    }, {threshold: 0.02});
    observer.observe(hero);
    let t = 0;
    function drift() {
      cancelAnimationFrame(driftFrame);
      if (!active || document.hidden || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
      t += 0.00022;
      map.setBearing(-24 + Math.sin(t) * 1.5);
      driftFrame = requestAnimationFrame(drift);
    }
    drift();
    document.addEventListener('visibilitychange', () => {
      if (document.hidden) cancelAnimationFrame(driftFrame);
      else if (active) drift();
    });
    window.addEventListener('resize', () => map.resize(), {passive:true});
  }

  if (hero && art) {
    const loadMapLibre = () => {
      if (window.maplibregl) return startRealCity();
      const script = document.createElement('script');
      script.src = 'https://unpkg.com/maplibre-gl@4.7.1/dist/maplibre-gl.js';
      script.onload = startRealCity;
      script.onerror = () => art.classList.add('city-fallback');
      document.head.appendChild(script);
    };
    loadMapLibre();
  }
})();
