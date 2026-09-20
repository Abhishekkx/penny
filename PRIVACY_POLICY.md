# Privacy Policy for Pennora

**Last Updated:** September 20, 2026  
**Effective Date:** September 20, 2026  

This Privacy Policy describes how **Pennora** ("we", "us", or "our"), an offline-first personal finance tracking and AI budget coaching application developed by **Abhishek** (Application ID: `com.abhishekkx.pennora`), handles information when you use our mobile application (the "App").

We take your privacy seriously. Pennora is designed with an **offline-first, privacy-by-default architecture**. Your financial data belongs exclusively to you and remains on your physical device.

---

## 1. Information Collection and Storage

### 1.1 Local Data Storage (On-Device)
All financial records, transaction histories, expense/income logs, custom category preferences, budget limits, and user profile settings entered into Pennora are saved exclusively in a local SQLite database on your device using the Drift database framework. 

* **No External Database Servers:** We do not own, operate, or transmit your financial logs to any external cloud databases or centralized servers.
* **No User Accounts:** Pennora does not require you to create an account, log in with an email address, or provide personal identifiable information (PII) such as your full name, phone number, or government identity.

### 1.2 Google Gemini AI Feature ("Talk to Pocket")
Pennora includes an optional AI financial assistant feature ("Talk to Pocket"). When you explicitly ask questions or interact with the AI assistant:
* **Data Transmitted:** The App packages your local financial database context (e.g., spending categories, total expenditure, income figures) along with your query and securely transmits it via encrypted HTTPS directly to the **Google Gemini API** (`generativelanguage.googleapis.com`).
* **Purpose:** This data is sent solely to generate instant, personalized financial advice and analysis requested by you.
* **Third-Party Processing:** Processing is governed by [Google's Privacy Policy](https://policies.google.com/privacy) and [Google AI Terms of Service](https://ai.google.dev/terms). We do not store your prompt history or financial queries on any developer servers.

---

## 2. Device Permissions Used

Pennora requests only the minimal device permissions necessary to deliver core features:

1. **`android.permission.INTERNET`**:
   * **Purpose:** Required to send queries to the Google Gemini API when you use the "Talk to Pocket" AI assistant and to download optional Google Fonts.
   * **Usage:** Never used to run background telemetry, analytics, or background data exfiltration.

2. **`android.permission.POST_NOTIFICATIONS`**:
   * **Purpose:** Required to deliver local budget pacing notifications, daily expense reminders, and milestone alerts.
   * **Usage:** Notifications are generated locally by your device. No remote push server is involved.

---

## 3. Data Safety & Analytics

* **No Advertising or Trackers:** Pennora contains zero third-party advertising SDKs, zero marketing trackers, and zero behavioral profiling tools.
* **No Telemetry / Usage Tracking:** We do not track your app usage habits, click paths, or screen views.
* **No Financial Account Credentials:** Pennora NEVER requests your bank account numbers, credit card details, passwords, CVVs, or online banking credentials.

---

## 4. User Data Control & Deletion Instructions

Because all your data is stored locally on your physical device, **you have 100% control over your data at all times**:

### How to Delete Your Data:
1. **In-App Reset:** Open **Settings** inside Pennora and tap **"Reset All Data"**. This instantly and permanently deletes all transactions, budgets, settings, and database records from your device's local storage.
2. **Device Settings Clear:** Open your Android device **Settings -> Apps -> Pennora -> Storage & Cache -> Clear Storage / Clear Data**.
3. **Uninstall Application:** Uninstalling Pennora from your device completely and permanently deletes the local SQLite database and all associated local files.

---

## 5. CSV Data Export

Pennora provides a native CSV export feature allowing you to export your transaction records (`Date, Time, Category, Type, Amount, Essential Need, Note`). The generated CSV file is saved locally in your device's temporary folder and shared only through native Android system share sheets when you explicitly trigger an export.

---

## 6. Children's Privacy

Pennora is not directed at children under the age of 13. We do not knowingly collect or solicit personal information from anyone under 13 years of age.

---

## 7. Changes to This Privacy Policy

We may update our Privacy Policy from time to time. Any changes will be reflected by updating the "Last Updated" date at the top of this document. We encourage users to review this Privacy Policy periodically.

---

## 8. Contact Us

If you have any questions, suggestions, or concerns regarding this Privacy Policy or Pennora's privacy practices, please contact us:

* **Developer:** Abhishek
* **GitHub Repository:** [https://github.com/Abhishekkx/penny](https://github.com/Abhishekkx/penny)
* **Issue Tracker:** [https://github.com/Abhishekkx/penny/issues](https://github.com/Abhishekkx/penny/issues)
