# Template Variables Documentation

Complete reference for all Jinja2 variables available in the Netwatch subscription template.

---

## 📋 Table of Contents

- [User Object](#user-object)
- [Links List](#links-list)
- [Apps List](#apps-list)
- [Filters](#filters)
- [Control Flow](#control-flow)
- [Usage Examples](#usage-examples)

---

## 👤 User Object

The main `user` object contains all subscription and account information.

### Basic Information

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `{{ user.username }}` | string | User's unique username | `"john_doe"` |
| `{{ user.status }}` | object | Account status object | See [Status Object](#status-object) |
| `{{ user.status.value }}` | string | Status string value | `"active"`, `"expired"`, `"limited"`, `"disabled"`, `"on_hold"` |

### Data Usage

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `{{ user.data_limit }}` | integer | Total data limit in bytes | `53687091200` (50 GB) |
| `{{ user.used_traffic }}` | integer | Used traffic in bytes | `21474836480` (20 GB) |
| `{{ user.data_limit_reset_strategy }}` | object/string | How often data resets | `"monthly"`, `"weekly"`, `"daily"`, `"no_reset"` |

**Check for unlimited data:**
```jinja
{% if '-unlimit' in user.username or not user.data_limit %}
  <!-- User has unlimited data -->
{% endif %}
```

### Time-Based Information

| Variable | Type | Description | Format |
|----------|------|-------------|--------|
| `{{ user.expire }}` | datetime | Expiration date/time | `2024-12-31 23:59:59` |
| `{{ user.on_hold_timeout }}` | datetime | When on-hold period ends | `2024-02-15 10:00:00` |
| `{{ user.on_hold_expire_duration }}` | integer | On-hold duration in seconds | `2592000` (30 days) |

**Calculate remaining days:**
```jinja
{% set current_datetime = now() %}
{% set remaining_days = ((user.expire - current_datetime).days) %}
{{ remaining_days | int }} days remaining
```

---

## 🔗 Links List

Array of subscription configuration links.

### Usage

```jinja
{% for link in links %}
  {{ link }}  <!-- Full subscription URL -->
  {{ loop.index }}  <!-- 1-based index -->
{% endfor %}
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `{{ links }}` | list | Array of all subscription URLs |
| `{{ links|length }}` | integer | Total number of links |

### Example

```jinja
{% if links %}
  <p>You have {{ links|length }} subscription link(s)</p>
  {% for link in links %}
    <div>Link #{{ loop.index }}: {{ link }}</div>
  {% endfor %}
{% endif %}
```

---

## 📱 Apps List

Array of recommended application objects.

### App Object Structure

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `{{ app.name }}` | string | Application name | `"V2rayNG"` |
| `{{ app.platform }}` | object | Platform object | See below |
| `{{ app.platform.value }}` | string | Platform identifier | `"android"`, `"ios"`, `"windows"`, `"macos"`, `"linux"` |
| `{{ app.recommended }}` | boolean | Whether app is recommended | `true` / `false` |
| `{{ app.icon_url }}` | string | URL to app icon | `"https://example.com/icon.png"` |
| `{{ app.description }}` | object | Descriptions by language | `{"en": "...", "fa": "..."}` |
| `{{ app.download_links }}` | list | Array of download link objects | See [Download Links](#download-links) |
| `{{ app.import_url }}` | string | One-click import URL | `"v2rayng://install-config?url=..."` |

### Download Links

Each app can have multiple download links:

```jinja
{% for link in app.download_links %}
  {{ link.name }}  <!-- Link display name -->
  {{ link.url }}   <!-- Download URL -->
  {{ link.language.value }}  <!-- "en" or "fa" -->
{% endfor %}
```

### Filter Apps by Platform

```jinja
{# Get all Android apps #}
{% set android_apps = apps | selectattr('platform') | selectattr('platform.value', 'equalto', 'android') | list %}

{# Get apps without platform #}
{% set no_platform = apps | rejectattr('platform') | list %}
```

### Group Apps by Platform

```jinja
{# Get unique platforms #}
{% set platforms = [] %}
{% for app in apps %}
  {% if app.platform and app.platform.value not in platforms %}
    {% set _ = platforms.append(app.platform.value) %}
  {% endif %}
{% endfor %}

{# Loop through each platform #}
{% for platform in platforms %}
  <h3>{{ platform }}</h3>
  {% for app in apps %}
    {% if app.platform and app.platform.value == platform %}
      <!-- Display app -->
    {% endif %}
  {% endfor %}
{% endfor %}
```

---

## 🎨 Filters

Pasarguard provides custom Jinja2 filters for formatting.

### `bytesformat`

Converts bytes to human-readable format.

```jinja
{{ user.used_traffic | bytesformat }}
<!-- Output: "20.5 GB" -->

{{ user.data_limit | bytesformat }}
<!-- Output: "50 GB" -->
```

### `datetime`

Formats datetime objects.

```jinja
{{ user.expire | datetime }}
<!-- Output: "2024-12-31 23:59:59" -->
```

### Built-in Jinja2 Filters

```jinja
{{ user.username | upper }}  <!-- JOHN_DOE -->
{{ user.username | lower }}  <!-- john_doe -->
{{ remaining_days | int }}   <!-- 45 -->
{{ percentage | round(2) }}  <!-- 75.50 -->
```

---

## 🔄 Control Flow

### Status Checks

```jinja
{% if user.status.value == 'active' %}
  <!-- Account is active -->
{% elif user.status.value == 'limited' %}
  <!-- Data limit reached -->
{% elif user.status.value == 'expired' %}
  <!-- Subscription expired -->
{% elif user.status.value == 'on_hold' %}
  <!-- Account on hold -->
{% elif user.status.value == 'disabled' %}
  <!-- Account disabled -->
{% endif %}
```

### Show Content Only for Active Users

```jinja
{% if user.status in ('active', 'on_hold') %}
  <!-- Show subscription links -->
  {{ links }}
{% endif %}
```

### Check for Expiration

```jinja
{% if user.expire %}
  {% set current_datetime = now() %}
  {% set remaining_days = ((user.expire - current_datetime).days) %}

  {% if remaining_days < 3 %}
    <div class="warning">Subscription expires soon!</div>
  {% endif %}
{% else %}
  <div>Unlimited expiration</div>
{% endif %}
```

### Conditional Data Limit Display

```jinja
{% if '-unlimit' in user.username %}
  <span>∞ Unlimited</span>
{% elif not user.data_limit %}
  <span>∞</span>
{% else %}
  <span>{{ user.data_limit | bytesformat }}</span>
{% endif %}
```

---

## 💡 Usage Examples

### Example 1: Data Usage Progress Bar

```jinja
{% if user.data_limit and '-unlimit' not in user.username %}
  {% set percentage = (user.used_traffic / user.data_limit * 100) | round(1) %}

  <div class="progress-bar">
    <div class="fill" style="width: {{ percentage }}%"></div>
  </div>
  <p>{{ percentage }}% used</p>
{% endif %}
```

### Example 2: Status Badge with Icon

```jinja
<span class="badge badge--{{ user.status.value }}">
  <span class="dot"></span>
  {% if user.status.value == 'active' %}
    ✓ Active
  {% elif user.status.value == 'expired' %}
    ⚠ Expired
  {% elif user.status.value == 'on_hold' %}
    ⏸ On Hold
  {% endif %}
</span>
```

### Example 3: Multi-Language App Descriptions

```jinja
{% for app in apps %}
  <div class="app">
    <h3>{{ app.name }}</h3>

    {# Show English description #}
    {% if app.description.en %}
      <p lang="en">{{ app.description.en }}</p>
    {% endif %}

    {# Show Persian description #}
    {% if app.description.fa %}
      <p lang="fa">{{ app.description.fa }}</p>
    {% endif %}
  </div>
{% endfor %}
```

### Example 4: Platform Icons

```jinja
{% if app.platform %}
  {% set platform = app.platform.value | lower %}

  {% if platform == 'android' %}
    <span class="icon">🤖</span>
  {% elif platform == 'ios' %}
    <span class="icon"></span>
  {% elif platform == 'windows' %}
    <span class="icon">💻</span>
  {% elif platform in ('macos', 'mac') %}
    <span class="icon">🍎</span>
  {% elif platform == 'linux' %}
    <span class="icon">🐧</span>
  {% else %}
    <span class="icon">📱</span>
  {% endif %}
{% endif %}
```

### Example 5: Reset Strategy Display

```jinja
{% if user.data_limit_reset_strategy != 'no_reset' %}
  <small>(Resets every {{ user.data_limit_reset_strategy.value }})</small>
{% endif %}
```

---

## 📚 Additional Resources

- [Jinja2 Documentation](https://jinja.palletsprojects.com/)
- [Pasarguard Documentation](https://github.com/pasarguard/pasarguard)
- [Template Filters Reference](https://jinja.palletsprojects.com/en/3.1.x/templates/#builtin-filters)

---

## 🐛 Debugging

To see all available variables, add this temporarily to your template:

```jinja
<pre style="direction: ltr; text-align: left;">
{{ user | tojson(indent=2) }}
</pre>
```

**Note:** Remove this before production use!

---

**Last Updated:** 2024-02-08
**Pasarguard Version:** 0.1.0+
