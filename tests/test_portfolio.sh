#!/bin/zsh

set -u

repo_root=${0:a:h:h}
failures=0

pass() {
  print "PASS: $1"
}

fail() {
  print -u2 "FAIL: $1"
  failures=$((failures + 1))
}

assert_contains() {
  local file=$1
  local pattern=$2
  local label=$3

  if rg -q --fixed-strings -- "$pattern" "$file"; then
    pass "$label"
  else
    fail "$label"
  fi
}

assert_matches() {
  local file=$1
  local pattern=$2
  local label=$3

  if rg -q -- "$pattern" "$file"; then
    pass "$label"
  else
    fail "$label"
  fi
}

assert_not_contains() {
  local file=$1
  local pattern=$2
  local label=$3

  if rg -qi --fixed-strings -- "$pattern" "$file"; then
    fail "$label"
  else
    pass "$label"
  fi
}

html="$repo_root/index.html"
css="$repo_root/assets/css/main.css"
js="$repo_root/assets/js/main.js"
robots="$repo_root/robots.txt"
sitemap="$repo_root/sitemap.xml"

for section_id in home work about experience contact; do
  assert_contains "$html" "id=\"$section_id\"" "section #$section_id exists"
done

for dependency in bootstrap.min.css bootstrap.bundle.min.js aos.css aos.js typed.umd.js purecounter waypoints isotope.pkgd glightbox swiper-bundle; do
  assert_not_contains "$html" "$dependency" "old dependency $dependency is not loaded"
done

for marker in 'class="skip-link"' 'id="main-content"' 'id="nav-toggle"' 'aria-controls="site-nav"' 'id="theme-toggle"' 'aria-label="Toggle color theme"'; do
  assert_contains "$html" "$marker" "accessible marker $marker exists"
done

for content in '10+' '7+' '500K+' ORKAI Ramorie SentScan; do
  assert_contains "$html" "$content" "verified content $content exists"
done

assert_matches "$html" '<h1([[:space:]>])' "document has an h1"
h1_count=$(rg -o '<h1([[:space:]>])' "$html" | wc -l | tr -d ' ')
if [[ "$h1_count" == "1" ]]; then
  pass "document has exactly one h1"
else
  fail "document has exactly one h1"
fi

assert_not_contains "$html" ' style="' "document has no inline styles"
assert_contains "$html" '&amp;family=Outfit' "remote font URL is valid HTML"
assert_not_contains "$html" '<span></span>' "document has no empty spans"
assert_matches "$html" '<img[^>]+alt="[^\"]+"[^>]+width="[0-9]+"[^>]+height="[0-9]+"' "images expose alt text and dimensions"
assert_matches "$html" 'target="_blank"[^>]+rel="noopener noreferrer"' "external blank-target links are isolated"

for seo_file in "$html" "$robots" "$sitemap"; do
  assert_contains "$seo_file" 'https://yusufterzioglu.com' "custom domain is declared in ${seo_file:t}"
  assert_not_contains "$seo_file" 'terzigolu.github.io/portfolio' "legacy GitHub Pages URL is absent from ${seo_file:t}"
done
assert_contains "$sitemap" 'https://yusufterzioglu.com/#experience' "sitemap uses the current experience anchor"
assert_contains "$sitemap" 'https://yusufterzioglu.com/#work' "sitemap uses the current work anchor"

for token in '--background: #0a0a0a' '--foreground: #f5f5f5' '--surface: #121212' '--border: #2a2a2a' 'html[data-theme="light"]' '--font-display' '--font-body' '--font-mono'; do
  assert_contains "$css" "$token" "CSS token $token exists"
done

assert_matches "$css" ':focus-visible' "visible focus styles exist"
assert_contains "$css" '.js [data-reveal]' "JS-gated reveal styles exist"
assert_contains "$css" '.is-visible' "visible reveal state exists"
assert_matches "$css" 'prefers-reduced-motion:[[:space:]]*reduce' "reduced motion is supported"
assert_not_contains "$css" '.theme-toggle { display: none; }' "theme control remains available at 320px"

for marker in 'const STORAGE_KEY = "yt-theme"' IntersectionObserver prefers-reduced-motion 'setAttribute("aria-expanded"' 'document.documentElement.dataset.theme'; do
  assert_contains "$js" "$marker" "JavaScript behavior $marker exists"
done

if (( failures > 0 )); then
  print -u2 "\n$failures portfolio contract check(s) failed."
  exit 1
fi

print "\nAll portfolio contract checks passed."
