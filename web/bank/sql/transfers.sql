SELECT
  accounts.user_id AS user_id,
  accounts.bank_id AS bank_id,
	SUM(CASE
		WHEN accounts.id = transfers.source_account_id
			THEN transfers.amount * -1
		WHEN accounts.id = transfers.target_account_id
			THEN transfers.amount
		ELSE
			0.00
		END)
	AS balance
FROM
    accounts
LEFT JOIN transfers ON
    transfers.source_account_id = accounts.id
    OR transfers.target_account_id = accounts.id
GROUP BY accounts.id, accounts.user_id, accounts.bank_id
ORDER BY user_id ASC, balance ASC
