# Personal Budget App MVP - Product Requirements Document

## Product Overview

The Personal Budget App is a mobile-first application designed to help users manage their personal finances by tracking expenses, income, and budget across multiple accounts. The app provides intuitive interfaces for financial management and visualization of spending patterns.

## Business Objectives

- Provide users with a simple yet powerful tool to manage personal finances
- Help users track and categorize expenses across multiple accounts
- Enable users to monitor their budget status over different time periods
- Allow planning of future financial transactions

## Target Users

- Individuals and families wanting to manage personal finances
- Users who need to track expenses across multiple accounts (personal, joint, etc.)
- Budget-conscious individuals looking for visual representation of their financial status

## Technical Requirements

- Primary platform: Mobile application
- Development framework: Quasar (https://quasar.dev/)
- Responsive design for potential future web access
- Secure local data storage with optional cloud sync

## Feature Requirements

### 1. Account Management

#### 1.1 Account Types

- **Must Have**: Support for multiple account types (Cash, Credit Cards, Bank Deposits, Loans)
- **Must Have**: Visual differentiation between positive and negative balance accounts
- **Should Have**: Custom naming for accounts (e.g., "Wife's credit card")

#### 1.2 Account Operations

- **Must Have**: View account balances individually and as a total
- **Must Have**: Add/Edit/Delete accounts
- **Should Have**: Quick account selection interface

### 2. Transaction Management

#### 2.1 Transaction Types

- **Must Have**: Support for income transactions (e.g., Salary, Rental revenue)
- **Must Have**: Support for expense transactions (e.g., Food, Car, Coffee)
- **Must Have**: Categorization of transactions

#### 2.2 Transaction Operations

- **Must Have**: Add new transactions with amount, category, and timestamp
- **Must Have**: View transactions grouped by date/category
- **Must Have**: Edit existing transactions
- **Should Have**: Delete transactions
- **Should Have**: Recurring transaction setup

### 3. Budget Overview

#### 3.1 Time-based Views

- **Must Have**: Daily, Weekly, Monthly, and Yearly views
- **Must Have**: Balance calculation with percentage change indicators
- **Should Have**: Progress visualization (e.g., circular progress indicator)

#### 3.2 Financial Summary

- **Must Have**: Total balance across all accounts
- **Must Have**: Income vs. Expenses summary
- **Should Have**: Budget progress visualization (45% as shown in mockup)

### 4. User Interface

#### 4.1 Navigation

- **Must Have**: Clear navigation between account views and transaction views
- **Must Have**: Back button for nested screens
- **Must Have**: Search functionality for transactions

#### 4.2 Design Elements

- **Must Have**: Color coding for income (green/blue) and expenses (red)
- **Must Have**: Consistent iconography for transaction categories
- **Must Have**: Clean, uncluttered screens with appropriate whitespace

#### 4.3 Settings & Personalization

- **Must Have**: Centralized settings page accessible from main navigation
- **Must Have**: Manage categories from settings page
- **Must Have**: User can select preferred currency symbol (e.g., $, €, £, etc.)
- **Must Have**: User can choose symbol position (before, after, or none)
- **Must Have**: User can choose number formatting style (comma: 17,000.50 or plain: 170000)

## User Flows

### Primary User Flows

1. **View Overall Financial Status**:

   - Open app → View "All Accounts" summary
   - Navigate between time periods (Daily/Weekly/Monthly/Yearly)

2. **View Individual Account**:

   - Open app → Select specific account from list
   - View account transactions and balance

3. **Add New Transaction**:

   - Open app → Navigate to relevant account
   - Tap "+" icon → Enter transaction details → Save

4. **View Budget Progress**:

   - Open app → Select time period (Monthly)
   - View circular progress indicator and income/expense breakdown

5. **Personalize App Settings**:
   - Open app → Navigate to Settings from main menu
   - Change currency symbol, symbol position, or number formatting
   - Manage categories from settings page
   - See changes reflected throughout the app

## Mockup Alignment

The provided mockups illustrate:

1. All Accounts overview with negative net worth (-$171,559.80)
2. Cash account view showing positive balance ($23,092.20)
3. Cash account with pulled/expanded transaction details
4. Account operation popup showing Operation/Account/Cancel options
5. Monthly view with budget progress indicator (45%)

## Non-Functional Requirements

- **Performance**: App should load within 2 seconds, transaction operations should complete in under 1 second
- **Usability**: Intuitive interface suitable for users with basic tech proficiency
- **Reliability**: Data should never be lost, even if app crashes
- **Security**: Financial data should be securely stored

## Future Considerations (Post-MVP)

- Cloud synchronization across devices
- Budgeting goals and limits
- Financial projections and forecasting
- Reports and analytics
- Tablet/desktop optimized views
- Data export functionality
- Bill reminders and notifications
- Multi-currency support

## Development Timeline (Suggested)

- **Phase 1** (Weeks 1-2): Basic UI implementation and account structure
- **Phase 2** (Weeks 3-4): Transaction management and data persistence
- **Phase 3** (Weeks 5-6): Budget visualization and time-based views
- **Phase 4** (Weeks 7-8): Testing, refinement and MVP launch

## Success Metrics

- Successful implementation of all "Must Have" features
- App performance meets defined non-functional requirements
- Intuitive navigation matching the mockup designs
- Accurate financial calculations and summaries
