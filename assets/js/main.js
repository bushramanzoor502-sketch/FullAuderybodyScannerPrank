/* FullAudery website — small, dependency-free interactions. */
(function () {
  'use strict';

  /* ---- Mobile nav ---- */
  var toggle = document.querySelector('.nav-toggle');
  var links  = document.querySelector('.nav-links');

  if (toggle && links) {
    toggle.addEventListener('click', function () {
      var open = links.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(open));
    });

    links.addEventListener('click', function (e) {
      if (e.target.tagName === 'A') {
        links.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
      }
    });
  }

  /* ---- Sticky header shadow + back-to-top visibility ---- */
  var header = document.querySelector('.site-header');
  var toTop  = document.querySelector('.to-top');

  var onScroll = function () {
    var y = window.scrollY;
    if (header) header.classList.toggle('is-stuck', y > 8);
    if (toTop)  toTop.classList.toggle('show', y > 700);
  };
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  /* ---- Scrollspy: highlight the nav link for the section in view ----
     Everything lives on one page now, so the nav is the only orientation
     cue the reader gets. */
  var navAnchors = [].slice.call(document.querySelectorAll('.nav-links a[href^="#"]'));
  var spied = navAnchors
    .map(function (a) {
      var el = document.querySelector(a.getAttribute('href'));
      return el ? { link: a, section: el } : null;
    })
    .filter(Boolean);

  if (spied.length) {
    var setActive = function (link) {
      navAnchors.forEach(function (a) { a.removeAttribute('aria-current'); });
      if (link) link.setAttribute('aria-current', 'page');
    };

    var spy = function () {
      var probe = window.scrollY + 140;   // just under the sticky header
      var current = null;
      spied.forEach(function (entry) {
        if (entry.section.offsetTop <= probe) current = entry.link;
      });
      // Bottom of the page: always light up the last section.
      if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 4) {
        current = spied[spied.length - 1].link;
      }
      setActive(current);
    };

    window.addEventListener('scroll', spy, { passive: true });
    window.addEventListener('resize', spy);
    spy();
  }


  /* ---- Contact: copy the support address ----
     A mailto: link does nothing on a device with no mail handler configured, so the
     address is copyable as plain text as well. */
  var copyBtn = document.getElementById('copyEmail');
  var copyNote = document.getElementById('copyNote');
  if (copyBtn) {
    var noteDefault = copyNote ? copyNote.textContent : '';
    copyBtn.addEventListener('click', function () {
      var email = copyBtn.getAttribute('data-email') || '';

      var done = function (ok) {
        if (!copyNote) return;
        copyNote.textContent = ok
          ? 'Copied ' + email + ' to your clipboard.'
          : 'Could not copy automatically. The address is ' + email;
        copyNote.classList.toggle('is-copied', ok);
        window.setTimeout(function () {
          copyNote.textContent = noteDefault;
          copyNote.classList.remove('is-copied');
        }, 4000);
      };

      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(email).then(function () { done(true); },
                                                  function () { done(false); });
        return;
      }
      // Older browsers, and any page not served over https.
      try {
        var ta = document.createElement('textarea');
        ta.value = email;
        ta.setAttribute('readonly', '');
        ta.style.position = 'fixed';
        ta.style.opacity = '0';
        document.body.appendChild(ta);
        ta.select();
        var ok = document.execCommand('copy');
        document.body.removeChild(ta);
        done(ok);
      } catch (e) {
        done(false);
      }
    });
  }

  /* ---- Before / after compare slider (mirrors the app's Result viewer) ---- */
  document.querySelectorAll('.compare').forEach(function (box) {
    var input = box.querySelector('input[type=range]');
    if (!input) return;
    var set = function () { box.style.setProperty('--pos', input.value + '%'); };
    input.addEventListener('input', set);
    set();
  });

  /* ---- Current year in the footer ---- */
  document.querySelectorAll('[data-year]').forEach(function (el) {
    el.textContent = String(new Date().getFullYear());
  });

  /* ---- Reveal on scroll ---- */
  var revealables = document.querySelectorAll('.reveal');
  if (!revealables.length) return;

  if (!('IntersectionObserver' in window)) {
    revealables.forEach(function (el) { el.classList.add('in'); });
    return;
  }

  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (!entry.isIntersecting) return;
      entry.target.classList.add('in');
      io.unobserve(entry.target);
    });
  }, { rootMargin: '0px 0px -60px 0px', threshold: 0.1 });

  revealables.forEach(function (el, i) {
    el.style.transitionDelay = Math.min(i % 4, 3) * 70 + 'ms';
    io.observe(el);
  });
})();
