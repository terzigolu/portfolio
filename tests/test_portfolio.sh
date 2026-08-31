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
llms="$repo_root/llms.txt"
llms_full="$repo_root/llms-full.txt"

for section_id in home work about experience contact; do
  assert_contains "$html" "id=\"$section_id\"" "section #$section_id exists"
done

for dependency in bootstrap.min.css bootstrap.bundle.min.js aos.css aos.js typed.umd.js purecounter waypoints isotope.pkgd glightbox swiper-bundle; do
  assert_not_contains "$html" "$dependency" "old dependency $dependency is not loaded"
done

for marker in 'class="skip-link"' 'id="main-content"' 'id="nav-toggle"' 'aria-controls="site-nav"' 'id="theme-toggle"' 'aria-label="Toggle color theme"'; do
  assert_contains "$html" "$marker" "accessible marker $marker exists"
done

assert_contains "$html" 'class="wordmark-avatar"' "header uses Yusuf's profile avatar"
assert_contains "$html" 'src="assets/img/55751392.jpeg" class="wordmark-avatar"' "header avatar uses the existing profile photo"
assert_not_contains "$html" 'class="wordmark-mark"' "header initials are removed"

for content in '10+' '7+' '500K+' Ramorie SentScan; do
  assert_contains "$html" "$content" "verified content $content exists"
done

assert_not_contains "$html" 'ORKAI' "retired ORKAI brand is absent"
assert_contains "$html" 'href="https://sentscan.com"' "SentScan uses its current URL"
assert_contains "$html" '>sentscan.com<' "SentScan URL is visible in the project identity"
assert_contains "$html" '>ramorie.com<' "Ramorie URL is visible in the project identity"
assert_contains "$html" 'href="https://www.turna.com/"' "current Turna.com experience links to the employer"
assert_contains "$html" 'Turna.com · 4 months' "current Turna.com tenure is visible"
assert_contains "$html" '"url": "https://www.turna.com/"' "structured data links the current Turna.com employer"
assert_contains "$html" 'class="project-identity"' "featured projects use text-only identity panels"
assert_not_contains "$html" 'assets/img/portfolio/orkai-' "ORKAI screenshots are not rendered"
assert_not_contains "$html" 'assets/img/portfolio/ramorie-' "Ramorie screenshots are not rendered"

assert_matches "$html" '<h1([[:space:]>])' "document has an h1"
h1_count=$(rg -o '<h1([[:space:]>])' "$html" | wc -l | tr -d ' ')
if [[ "$h1_count" == "1" ]]; then
  pass "document has exactly one h1"
else
  fail "document has exactly one h1"
fi

assert_not_contains "$html" ' style="' "document has no inline styles"
assert_not_contains "$html" '<div class="system-map" aria-label=' "system map does not misuse aria-label on a generic div"
time_count=$(rg -o '<time([[:space:]>])' "$html" | wc -l | tr -d ' ')
datetime_count=$(rg -o '<time datetime="[^"]+"' "$html" | wc -l | tr -d ' ')
if [[ "$time_count" == "$datetime_count" ]]; then
  pass "every time element has a machine-readable datetime"
else
  fail "every time element has a machine-readable datetime"
fi
assert_contains "$html" '<title>Yusuf Terzioglu — AI Software Architect</title>' "title is concise and descriptive"
assert_not_contains "$html" 'name="keywords"' "obsolete meta keywords are absent"
assert_contains "$html" 'property="og:type" content="profile"' "Open Graph identifies a personal profile"
assert_contains "$html" 'property="og:image:alt"' "Open Graph image has alternative text"
assert_contains "$html" 'property="og:image:width" content="400"' "Open Graph image width matches the source asset"
assert_contains "$html" 'property="og:image:height" content="400"' "Open Graph image height matches the source asset"
assert_contains "$html" 'name="twitter:image:alt"' "Twitter image has alternative text"
assert_contains "$html" 'name="twitter:card" content="summary"' "Twitter card matches the square profile image"
assert_contains "$html" 'rel="me" href="https://github.com/terzigolu"' "GitHub identity link is declared"
assert_contains "$html" 'rel="me" href="https://www.linkedin.com/' "LinkedIn identity link is declared"
assert_contains "$html" 'rel="alternate" type="text/plain" href="https://yusufterzioglu.com/llms.txt"' "AI-readable summary is discoverable"
assert_contains "$html" '&amp;family=Outfit' "remote font URL is valid HTML"
assert_not_contains "$html" '<span></span>' "document has no empty spans"
assert_matches "$html" '<img[^>]+alt="[^\"]+"[^>]+width="[0-9]+"[^>]+height="[0-9]+"' "images expose alt text and dimensions"
assert_matches "$html" 'target="_blank"[^>]+rel="noopener noreferrer"' "external blank-target links are isolated"

for seo_file in "$html" "$robots" "$sitemap"; do
  assert_contains "$seo_file" 'https://yusufterzioglu.com' "custom domain is declared in ${seo_file:t}"
  assert_not_contains "$seo_file" 'terzigolu.github.io/portfolio' "legacy GitHub Pages URL is absent from ${seo_file:t}"
done
json_ld_count=$(rg -o 'type="application/ld\+json"' "$html" | wc -l | tr -d ' ')
if [[ "$json_ld_count" == "1" ]]; then
  pass "document exposes one canonical JSON-LD graph"
else
  fail "document exposes one canonical JSON-LD graph"
fi
assert_contains "$html" '"@graph"' "structured data uses a connected graph"
for schema_type in ProfilePage Person WebSite ItemList SoftwareApplication; do
  assert_contains "$html" "\"@type\": \"$schema_type\"" "structured data includes $schema_type"
done
assert_not_contains "$html" '"@type": "BreadcrumbList"' "single-page sections are not represented as breadcrumbs"
assert_not_contains "$html" '"price": "0"' "structured data does not invent free pricing"

if [[ -f "$llms" ]]; then
  pass "llms.txt exists"
else
  fail "llms.txt exists"
fi
if [[ -f "$llms_full" ]]; then
  pass "llms-full.txt exists"
else
  fail "llms-full.txt exists"
fi
for ai_file in "$llms" "$llms_full"; do
  assert_contains "$ai_file" 'https://yusufterzioglu.com/' "${ai_file:t} declares the canonical portfolio"
  assert_contains "$ai_file" 'https://sentscan.com' "${ai_file:t} links SentScan"
  assert_contains "$ai_file" 'https://ramorie.com' "${ai_file:t} links Ramorie"
  assert_contains "$ai_file" 'https://www.turna.com/' "${ai_file:t} links the current Turna.com employer"
done
assert_contains "$llms_full" 'Okan University — Mobile Technologies, 2017.' "AI profile matches visible Okan education"
assert_contains "$llms_full" 'Anadolu University — History, undergraduate, ongoing.' "AI profile matches visible Anadolu education"
assert_not_contains "$llms_full" 'Electrical & Electronics Engineering' "AI profile does not invent an Okan degree"
assert_not_contains "$llms_full" 'Management Information Systems' "AI profile does not invent an Anadolu degree"

for crawler in OAI-SearchBot ChatGPT-User GPTBot Claude-SearchBot Claude-User ClaudeBot PerplexityBot Google-Extended; do
  assert_contains "$robots" "User-agent: $crawler" "robots.txt explicitly addresses $crawler"
done

assert_not_contains "$sitemap" '#' "sitemap contains only canonical crawlable URLs"
sitemap_url_count=$(rg -o '<loc>' "$sitemap" | wc -l | tr -d ' ')
if [[ "$sitemap_url_count" == "1" ]]; then
  pass "single-page portfolio sitemap exposes one canonical URL"
else
  fail "single-page portfolio sitemap exposes one canonical URL"
fi

for legacy_page in portfolio-details.html service-details.html starter-page.html; do
  if [[ ! -e "$repo_root/$legacy_page" ]]; then
    pass "obsolete template route $legacy_page is removed"
  else
    fail "obsolete template route $legacy_page is removed"
  fi
done

for token in '--background: #0a0a0a' '--foreground: #f5f5f5' '--surface: #121212' '--border: #2a2a2a' 'html[data-theme="light"]' '--font-display' '--font-body' '--font-mono'; do
  assert_contains "$css" "$token" "CSS token $token exists"
done

assert_matches "$css" ':focus-visible' "visible focus styles exist"
assert_contains "$css" '.js [data-reveal]' "JS-gated reveal styles exist"
assert_contains "$css" '.is-visible' "visible reveal state exists"
assert_matches "$css" 'prefers-reduced-motion:[[:space:]]*reduce' "reduced motion is supported"
assert_not_contains "$css" '.theme-toggle { display: none; }' "theme control remains available at 320px"
assert_contains "$css" '.wordmark-avatar {' "header avatar has dedicated responsive styling"
assert_contains "$css" '.project-identity { min-height: 220px; }' "project identity has a compact mobile layout contract"

for marker in 'const STORAGE_KEY = "yt-theme"' IntersectionObserver prefers-reduced-motion 'setAttribute("aria-expanded"' 'document.documentElement.dataset.theme'; do
  assert_contains "$js" "$marker" "JavaScript behavior $marker exists"
done

if (( failures > 0 )); then
  print -u2 "\n$failures portfolio contract check(s) failed."
  exit 1
fi

print "\nAll portfolio contract checks passed."
