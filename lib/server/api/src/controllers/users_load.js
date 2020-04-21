import User from '../models/User';
import LoadType from '../models/LoadType';
import UserLoadDetail from '../models/UserLoadDetail';
import UserCurrentLoad from '../models/UserCurrentLoad';
import UserPayDetail from '../models/UserPayDetail';
import UserLoadTransferDetail from '../models/UserLoadTransferDetail';

import validateInput from '../shared/validations/common';

export default {

  loadType: (req, res) => {
    LoadType.fetchAll().then(load =>
      res.json({ result: 1, load: load })
    ).catch(err =>
      res.status(500).json({ error: err })
    );
  },

  currentLoad: (req, res) => {
    const phone = req.params.phone;
    UserCurrentLoad.where({ phone: phone }).fetchAll().then((userload) =>
      res.json({ result: 1, userload: userload })
    ).catch(
      err => res.status(500).json({ error: 'Accout not found or load not enough' })
    );
  },

  loadMoney: (req, res) => {
    const { phone, amount, type, source } = req.body;
    const loadInfo = { phone, amount, type, source };
    const { errors, isValid } = validateInput(loadInfo, ['phone', 'amount', 'type', 'source']);

    const topLoad = (loadInfo) => {
      User.where({ phone: phone }).fetch().then(() => {
        UserLoadDetail.forge({ phone: phone, amount: amount, type_id: type, source_id: source }).save().then(
          () => res.json({ result: 1, description: `${amount} Load successfully` })
        );
      }).catch(
        err => res.status(500).json({ error: 'Accout not found' })
      );
    }

    isValid ? topLoad(phone, amount, type, source) : res.status(400).json(errors);
  },

  scanPay: (req, res) => {
    const { phone, amount, type, pay } = req.body;
    const payInfo = { phone, amount, type, pay };
    const { errors, isValid } = validateInput(payInfo, ['phone', 'amount', 'type', 'pay']);

    const payItem = (payInfo) => {
      UserCurrentLoad.where({phone: phone, type_id: type}).where('load', '>', amount).fetch().then(() => {
        UserPayDetail.forge({ phone: phone, amount: amount, type_id: type, pay_id: pay }).save().then(
          () => res.json({ result: 1, description: `${amount} Pay successfully` })
        );
      }).catch(
        err => res.status(500).json({ error: 'Accout not found or load not enough' })
      );
    }

    isValid ? payItem(phone, amount, type, pay) : res.status(400).json(errors);
  },

  loadTransfer: (req, res) => {
    const { phone, amount, transfer_to } = req.body;
    const transferInfo = { phone, amount, transfer_to };
    const { errors, isValid } = validateInput(transferInfo, ['phone', 'amount', 'transfer_to']);

    const transfer = (transferInfo) => {
      if (phone !== transfer_to) {
        UserCurrentLoad.where({phone: phone, type_id: 1}).where('load', '>', amount).fetch().then(() => {
          User.where({ phone: transfer_to }).fetch().then(() => {
            UserLoadTransferDetail.forge({ phone: phone, amount: amount, transfer_to: transfer_to }).save().then(() => {
              UserLoadDetail.forge({ phone: transfer_to, amount: amount, type_id: 1, source_id: 2, description: `Transfer from: ${phone}` }).save();
              res.json({ result: 1, description: `${amount} transfer to ${transfer_to} successfully` });
            });
          }).catch(
            err => res.status(500).json({ error: 'Accout transfer to not found' })
          );
        }).catch(
          err => res.status(500).json({ error: 'Accout not found or load not enough' })
        );
      } else {
        res.status(500).json({ error: 'Cant transfer to the same accout' })
      }
    }

    isValid ? transfer(phone, amount, transfer_to) : res.status(400).json(errors);
  },

}
