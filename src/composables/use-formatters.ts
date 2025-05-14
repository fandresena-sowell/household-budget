import { useHouseholdStore } from 'src/stores/household-store';

export function useFormatters() {
  /**
   * Format a number as currency based on household settings
   */
  function formatCurrency(value: number | null | undefined): string {
    if (value === null || value === undefined) {
      return ''; // Or maybe return a default like 'N/A' or format 0?
    }

    const householdStore = useHouseholdStore();
    const { currencySymbol, symbolPosition, numberFormat } = householdStore;

    let formattedNumber: string;

    // Handle number formatting
    if (numberFormat === 'plain') {
      formattedNumber = new Intl.NumberFormat('fr-FR').format(value);
    } else {
      formattedNumber = new Intl.NumberFormat('en-US').format(value);
    }

    // Handle negative sign placement relative to symbol
    const isNegative = value < 0;
    if (isNegative) {
      // Remove the minus sign for now, we'll add it back with the symbol
      formattedNumber = formattedNumber.replace('-', '');
    }

    // Add currency symbol and negative sign (if applicable)
    switch (symbolPosition) {
      case 'before':
        return `${isNegative ? '-' : ''}${currencySymbol} ${formattedNumber}`;
      case 'after':
        return `${isNegative ? '-' : ''}${formattedNumber} ${currencySymbol}`;
      case 'none':
      default:
        return `${isNegative ? '-' : ''}${formattedNumber}`;
    }
  }

  /**
   * Format a date based on the specified format
   */
  function formatDate(date: Date | string, format: string = 'DD/MM/YYYY'): string {
    const d = typeof date === 'string' ? new Date(date) : date;

    // Simple date formatter with basic formats
    const day = d.getDate().toString().padStart(2, '0');
    const month = (d.getMonth() + 1).toString().padStart(2, '0');
    const year = d.getFullYear().toString();

    switch (format) {
      case 'DD/MM/YYYY':
        return `${day}/${month}/${year}`;
      case 'MM/DD/YYYY':
        return `${month}/${day}/${year}`;
      case 'YYYY-MM-DD':
        return `${year}-${month}-${day}`;
      default:
        return `${day}/${month}/${year}`;
    }
  }

  /**
   * Format a percentage with the specified decimal places
   */
  function formatPercentage(value: number, decimalPlaces: number = 1): string {
    return `${value.toFixed(decimalPlaces)}%`;
  }

  return {
    formatCurrency,
    formatDate,
    formatPercentage,
  };
}
