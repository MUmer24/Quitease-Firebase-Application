# Security Policy

## 🔒 Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | ✅ Yes    |
| < 1.0   | ❌ No     |

---

## 🚨 Reporting a Vulnerability

If you discover a security vulnerability in QuitEase, **please do NOT open a public GitHub issue**.

**Report privately via:**
- **GitHub:** Use the [Private Security Advisory](../../security/advisories/new) feature
- **Email:** Contact the maintainer directly via GitHub profile

**Please include:**
1. Description of the vulnerability
2. Steps to reproduce
3. Potential impact assessment
4. Suggested fix (if known)

You will receive a response within **48 hours**. We take all reports seriously.

---

## 🛡 Security Architecture

### Authentication

| Method | Implementation | Notes |
|--------|---------------|-------|
| Google Sign-In | Firebase Auth + `google_sign_in` v7 | OAuth 2.0, ID token flow |
| Anonymous | Firebase `signInAnonymously()` | Guest mode — prompts to link |
| Account Linking | `linkWithCredential()` | Preserves all progress |

### Data Storage

| Data Type | Storage Location | Protection |
|-----------|-----------------|------------|
| User profile | Cloud Firestore | Firebase Auth UID scoped (apply rules below) |
| Smoking stats | `SharedPreferences` | App sandbox |
| Session state | `GetStorage` | App sandbox |
| Credentials | Never stored | OAuth flow only |
| Tokens | Firebase Auth SDK | Managed by SDK, not app code |

### Secrets Management

```
❌ NEVER store in code:    API keys, OAuth client IDs, Firebase keys
✅ Use:                    .env (local only, gitignored)
✅ In CI/CD:              GitHub Actions Secrets / environment variables
```

---

## 🔑 Environment Variables Reference

See [`.env.example`](.env.example) for the complete list of required variables.

| Variable | Source | Sensitivity |
|----------|--------|-------------|
| `FIREBASE_ANDROID_API_KEY` | Firebase Console | 🟡 Medium (restrict via SHA-1) |
| `FIREBASE_WEB_API_KEY` | Firebase Console | 🟡 Medium (restrict via domain) |
| `FIREBASE_ANDROID_APP_ID` | Firebase Console | 🟡 Medium |
| `FIREBASE_PROJECT_ID` | Firebase Console | 🟢 Low (not secret alone) |
| `GOOGLE_SERVER_CLIENT_ID` | Google Cloud Console | 🔴 High (restrict to app) |

---

## 🔐 Using flutter_dotenv

The app uses [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv) to load `.env`:

```dart
// In main.dart — add before runApp()
await dotenv.load(fileName: ".env");
```

```dart
// Reading a value
final clientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';
```

**Setup:**
```bash
# Copy the template
cp .env.example .env
# Fill in your values in .env
```

---

*Last reviewed: February 2026 — QuitEase v1.0.0*
