# Google Play Console Data Safety & Declaration Guide for Pennora

This document provides exact step-by-step responses to fill out all required declarations in the **Google Play Console** for **Pennora** (`com.abhishekkx.pennora`).

---

## 1. Data Safety Questionnaire

### Overview Section
* **Does your app collect or share any of the required user data types?**  
  👉 **Yes** (Only when optional AI feature is used by the user, financial context is processed via encrypted HTTPS to Google Gemini API for AI advice. No data is stored on developer servers or shared for advertising).
* **Is all of the user data collected by your app encrypted in transit?**  
  👉 **Yes** (All HTTPS communication to Google Gemini API uses TLS encryption).
* **Do you provide a way for users to request that their data be deleted?**  
  👉 **Yes**

---

### Data Deletion Request Disclosure
* **Provide your Privacy Policy URL:**  
  `https://abhishekkx.github.io/penny/privacy.html`
* **Provide a link that users can use to request that their data be deleted:**  
  `https://abhishekkx.github.io/penny/privacy.html#data-deletion`
* **How can users request data deletion?**  
  👉 Select: *"Users can delete their data directly within the app or by clearing app data / uninstalling the app."*
* **Description for Play Store listing:**  
  > "Pennora stores 100% of your financial data locally on your device. You can permanently delete all data at any time inside the app via Settings -> Reset All Data, or by clearing app storage in device settings."

---

### Data Types & Breakdown

| Data Category | Data Type | Collected? | Shared? | Encrypted in Transit? | Required or Optional? | Purpose |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Financial Info** | Financial Records / Expense Logs | **Yes** | **No** | **Yes** | Optional (only when using AI assistant) | App functionality (generating AI budget insights via Google Gemini API). Data is processed locally and not retained by developer servers. |
| **Personal Info** | Name / Email / Phone | **No** | **No** | N/A | N/A | Pennora requires no account creation or login. |
| **App Info & Performance** | Crash logs / Diagnostics | **No** | **No** | N/A | N/A | No crash reporting SDK installed. |
| **Device or Other IDs** | Device ID | **No** | **No** | N/A | N/A | Zero tracking SDKs installed. |

---

## 2. Financial Features Declaration

Google Play Console requires apps in the Finance category to declare their financial functionality:

* **Select Financial Categories that apply:**  
  👉 Select: **Personal Financial Management / Expense Tracker**
* **Does your app provide banking services, loans, or payment processing?**  
  👉 **No**
* **Does your app facilitate money transfers or cryptocurrency trading?**  
  👉 **No**
* **Does your app access financial account credentials or bank APIs?**  
  👉 **No**

---

## 3. App Content & Target Audience

* **Target Audience:**  
  👉 **13 and older** (Ages 13-15, 16-17, 18+)
* **Could your store listing unintentionally appeal to children?**  
  👉 **No**
* **News App Declaration:**  
  👉 **No** (Pennora is not a news app)
* **COVID-19 Contact Tracing / Status:**  
  👉 **No**
* **Ads Declaration:**  
  👉 **No, my app does not contain ads**
* **Government App:**  
  👉 **No**

---

## 4. Permission Declarations

### `android.permission.POST_NOTIFICATIONS`
* **Declaration Justification:**  
  > "Used to post local budget pacing notifications, threshold warnings, and daily expense reminders scheduled locally on the user's device."

### `android.permission.INTERNET`
* **Declaration Justification:**  
  > "Used strictly to communicate with Google Gemini API when the user explicitly triggers AI financial assistant queries and to load web typography fonts."
