# Contributing to Netwatch Subscription Template

Thank you for considering contributing to the Netwatch project! 🎉

[**فارسی**](#مشارکت-در-پروژه-netwatch) | English

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Guidelines](#coding-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

---

## 📜 Code of Conduct

This project adheres to a simple principle: **Be respectful and constructive**.

- Use welcoming and inclusive language
- Respect differing viewpoints and experiences
- Accept constructive criticism gracefully
- Focus on what's best for the community

---

## 🤝 How Can I Contribute?

### 1. Reporting Bugs

Found a bug? Help us fix it!

- **Check existing issues** to avoid duplicates
- Use the bug report template
- Include:
  - Clear description of the problem
  - Steps to reproduce
  - Expected vs actual behavior
  - Screenshots if applicable
  - Browser/OS information

### 2. Suggesting Enhancements

Have an idea to improve the template?

- **Check existing feature requests** first
- Use the feature request template
- Explain:
  - What problem does it solve?
  - How should it work?
  - Why is it valuable?

### 3. Code Contributions

Want to write code?

- Fix open issues (check "good first issue" label)
- Add new features from roadmap
- Improve documentation
- Optimize performance
- Enhance accessibility

### 4. Documentation

Help others understand the project:

- Fix typos and grammar
- Add examples to VARIABLES.md
- Translate documentation
- Write tutorials and guides

### 5. Design

Improve the visual experience:

- Suggest UI/UX improvements
- Create alternative color schemes
- Design new components
- Improve responsive layouts

---

## 🛠 Development Setup

### Prerequisites

- Text editor (VS Code, Sublime, etc.)
- Web browser with DevTools
- Git installed
- Basic knowledge of HTML, CSS, JavaScript

### Local Development

1. **Fork and Clone**
   ```bash
   git clone https://github.com/alixtron0/pasarguard-netwatch-sub.git
   cd netwatch-sub-template
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Test Your Changes**
   - Open `sub.html` in browser
   - Test with different user scenarios
   - Check responsive design (mobile, tablet, desktop)
   - Test RTL/LTR switching
   - Verify all interactive features

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: your descriptive message"
   ```

5. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

---

## 🎨 Coding Guidelines

### HTML

- Use semantic HTML5 elements
- Include ARIA labels for accessibility
- Keep structure clean and logical
- Comment complex sections

### CSS

- Use CSS variables for theming
- Follow BEM naming convention (`.block__element--modifier`)
- Keep selectors specific but not over-specific
- Group related properties together
- Add comments for complex styles

Example:
```css
/* ═══ COMPONENT NAME ═══ */
.component {
    /* Layout */
    display: flex;
    /* Spacing */
    padding: 10px;
    /* Colors */
    background: var(--bg-card);
    /* Typography */
    font-size: 0.9rem;
}
```

### JavaScript

- Use modern ES6+ syntax
- Follow existing code style
- Add comments for complex logic
- Use meaningful variable names
- Avoid global variables (use IIFE or modules)

Example:
```javascript
// ═══════════════════════════════════════
// FEATURE NAME
// ═══════════════════════════════════════
const featureName = () => {
    // Implementation
};
```

### Jinja2 Templates

- Use proper spacing and indentation
- Comment complex template logic
- Test with different data scenarios
- Handle edge cases (null, undefined, empty)

Example:
```jinja
{# Check for user status #}
{% if user.status.value == 'active' %}
    <!-- Active user content -->
{% endif %}
```

---

## 📤 Submitting Changes

### Pull Request Process

1. **Update Documentation**
   - Update README.md if needed
   - Add entry to CHANGELOG.md
   - Update VARIABLES.md if adding new variables

2. **Test Thoroughly**
   - Test on multiple browsers (Chrome, Firefox, Safari)
   - Test responsive breakpoints
   - Test with Pasarguard backend (if possible)
   - Check for console errors

3. **Create Pull Request**
   - Use a clear, descriptive title
   - Reference related issues (#123)
   - Describe what changed and why
   - Include screenshots for UI changes

4. **PR Title Convention**
   ```
   Add: New feature description
   Fix: Bug fix description
   Update: Changes to existing feature
   Docs: Documentation changes
   Style: CSS/visual changes
   Refactor: Code improvements
   ```

5. **Review Process**
   - Maintainers will review your PR
   - Address feedback promptly
   - Make requested changes
   - Squash commits if needed

---

## 🐛 Reporting Bugs

### Bug Report Template

```markdown
**Description**
Clear description of the bug.

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior**
What should happen.

**Actual Behavior**
What actually happens.

**Screenshots**
If applicable, add screenshots.

**Environment**
- Browser: [e.g., Chrome 120]
- OS: [e.g., Windows 11]
- Pasarguard Version: [e.g., 0.1.0]
- Template Version: [e.g., 1.0.0]

**Additional Context**
Any other relevant information.
```

---

## 💡 Suggesting Enhancements

### Feature Request Template

```markdown
**Feature Description**
Clear description of the feature.

**Problem it Solves**
What problem does this address?

**Proposed Solution**
How should it work?

**Alternatives Considered**
What other solutions did you think about?

**Additional Context**
Mockups, examples, or references.
```

---

## 🎯 Priority Labels

We use these labels to organize issues:

| Label | Description |
|-------|-------------|
| `good first issue` | Easy for newcomers |
| `bug` | Something isn't working |
| `enhancement` | New feature or request |
| `documentation` | Docs improvements |
| `help wanted` | Extra attention needed |
| `priority: high` | Critical issues |
| `priority: low` | Nice to have |

---

## ✅ Checklist Before Submitting PR

- [ ] Code follows project style guidelines
- [ ] Comments added for complex sections
- [ ] Documentation updated (README, CHANGELOG, VARIABLES)
- [ ] Tested on multiple browsers
- [ ] Tested responsive design
- [ ] No console errors
- [ ] RTL/LTR both work correctly
- [ ] Accessibility maintained
- [ ] Commit messages are clear

---

## 📞 Need Help?

- 💬 Open a [Discussion](https://github.com/alixtron0/pasarguard-netwatch-sub/discussions)
- 🐛 Report [Issues](https://github.com/alixtron0/pasarguard-netwatch-sub/issues)
- 📱 Contact on Telegram: [@netwatch_vpnbot](https://t.me/netwatch_vpnbot)

---

# مشارکت در پروژه Netwatch

از اینکه می‌خواهید در پروژه Netwatch مشارکت کنید متشکریم! 🎉

## 🤝 چگونه می‌توانم مشارکت کنم؟

### 1. گزارش باگ

- مشکلی پیدا کردید؟ به ما کمک کنید تا آن را رفع کنیم
- ابتدا Issue های موجود را بررسی کنید
- توضیح واضح از مشکل بدهید
- مراحل بازتولید باگ را شرح دهید

### 2. پیشنهاد ویژگی جدید

- ایده‌ای برای بهبود دارید؟
- توضیح دهید چه مشکلی را حل می‌کند
- نحوه عملکرد پیشنهادی را شرح دهید

### 3. کدنویسی

- Issue های باز را رفع کنید
- ویژگی‌های جدید اضافه کنید
- مستندات را بهبود دهید
- بهینه‌سازی‌های کد انجام دهید

## 📤 ارسال تغییرات

1. **Fork و Clone کنید**
   ```bash
   git clone https://github.com/alixtron0/pasarguard-netwatch-sub.git
   ```

2. **برنچ جدید بسازید**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **تغییرات را Test کنید**
   - در مرورگرهای مختلف تست کنید
   - حالت Responsive را بررسی کنید
   - RTL و LTR را امتحان کنید

4. **Pull Request ارسال کنید**
   - عنوان واضح و توصیفی بنویسید
   - تغییرات را شرح دهید
   - اسکرین‌شات اضافه کنید (برای تغییرات UI)

## ✅ چک‌لیست قبل از PR

- [ ] کد مطابق با استانداردهای پروژه است
- [ ] مستندات به‌روز شده است
- [ ] در مرورگرهای مختلف تست شده
- [ ] طراحی Responsive کار می‌کند
- [ ] خطایی در Console نیست
- [ ] RTL و LTR هر دو صحیح کار می‌کنند

---

**با تشکر از مشارکت شما! ❤️**
