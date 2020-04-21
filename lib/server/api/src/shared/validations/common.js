import validator from 'validator';
import isEmpty   from 'lodash/isEmpty';

export default function validateInput(data, fields) {
  let errors = {};

  for (let field of fields) {
    if (!data[field]) {
      errors[field] = `Please enter ${field}`;
    } else {
      if (field === 'email') {
        if (!validator.isEmail(data.email))
          errors[field] = 'Invalid email';
      } else if (field === 'cfmSecure') {
        if (data[field] !== data.newSecure)
          errors[field] = 'Not match';
      }
    }
  }

  return { errors, isValid: isEmpty(errors) }
}
