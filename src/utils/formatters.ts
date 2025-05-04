import { useHouseholdStore } from 'src/stores/household-store';
import { format } from 'date-fns';
/**
 * Formats a number as currency based on the current household's settings.
 *
 * @param value The numeric value to format.
 * @returns The formatted currency string.
 */
export function formatCurrency(value: number | null | undefined): string {
  if (value === null || value === undefined) {
    return ''; // Or maybe return a default like 'N/A' or format 0?
  }

  const householdStore = useHouseholdStore();
  const { currencySymbol, symbolPosition, numberFormat } = householdStore;

  let formattedNumber: string;

  // Handle number formatting
  if (numberFormat === 'plain') {
    // Remove existing commas and format with 0 decimal place
    formattedNumber = new Intl.NumberFormat('fr-FR').format(value);
  } else {
    // Default to 'comma' formatting with 2 decimal places
    // formattedNumber = value.toLocaleString(undefined, {
    //   // Use browser default locale
    //   minimumFractionDigits: 2,
    //   maximumFractionDigits: 2,
    // });
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

export function formatDate(date: string): string {
  return format(date, 'dd/MM/yyyy');
}
