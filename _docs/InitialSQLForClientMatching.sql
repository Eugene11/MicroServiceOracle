ALTER SESSION SET CURRENT_SCHEMA = SEAWARE;
SELECT t.IS_ACTIVE ,
  t.IS_DECEASED,
  t.FULL_NAME,
  t.CLIENT_ID ,
  t.HOUSEHOLD_ID,
  t.email,
  t.email_can_contact,
  SUBSTR( MST_Common.ClientIDMainPhone(t.CLIENT_ID),1,255) PHONE_NUMBER,
  (SELECT c.COUNTRY_NAME FROM Country c WHERE c.COUNTRY_CODE = a.COUNTRY_CODE
  ) COUNTRY_NAME,
  SUBSTR( a.ADDRESS_LINE1
  ||a.ADDRESS_LINE2
  || a.ADDRESS_LINE3
  ||a.ADDRESS_LINE4,1,100) ADDRESS,
  DECODE(NVL(a.ZIP,''),'','',a.ZIP,a.ZIP
  ||',')
  ||a.ADDRESS_CITY ZIP_CITY,
  SUBSTR( SW_POINTS_SUPPORT.ClientID2ClubAccountInfo(t.client_id),1,255) CLUB_ACCOUNT_INFO,
  (SELECT ca.account_no
  FROM PTS_CLUB_ACCOUNT ca,
    CLIENT_PROGRAM cp
  WHERE cp.client_id=t.client_id
  AND sysdate BETWEEN cp.DATE_FROM AND cp.DATE_TO
  AND ca.account_no = cp.club_account
  AND ca.is_active  ='Y'
  AND rownum        =1
  ) CLUB_ACCOUNT,
  t.TITLE ,
  t.FIRST_NAME ,
  t.MIDDLE_NAME ,
  t.LAST_NAME ,
  t.SSN,
  t.RANK,
  t.SEX ,
  t.BIRTHDAY ,
  t.DIRECTORY_NAME,
  t.AKA_FIRST_NAME,
  t.AKA_LAST_NAME,
  t.BIRTH_PLACE,
  t.COUNTRY_OF_BIRTH,
  t.CLIENT_TYPE ,
  t.GUEST_TYPE ,
  t.IS_SMOKER ,
  t.IS_HANDICAPPED ,
  t.OCCUPATION ,
  t.LANGUAGE_CODE ,
  t.CITIZENSHIP ,
  t.PASSPORT_NUMBER,
  t.PASSPORT_ISSUE_PLACE ,
  t.PASSPORT_ISSUE_DATE ,
  t.PASSPORT_EXP_DATE ,
  t.REFERRAL_TYPE ,
  t.REFERRAL_SOURCE ,
  t.REFERRAL_DATE ,
  t.REFERRAL_CLIENT_ID ,
  t.REFERRAL_HOUSEHOLD_ID ,
  t.WEB_LAST_LOGIN,
  t.WEB_LOGIN_NAME,
  t.WEB_PASSWORD,
  t.ALLOW_WEB_ACCESS,
  t.COMMENTS,
  t.HISTORICAL_CRUISES_NUM,
  t.HISTORICAL_DAYS_NUM,
  t.NOTIF_DFLT_DISTR_TYPE,
  t.SEND_PROMOTIONAL_MAIL,
  t.SEND_PROMOTIONAL_EMAIL,
  t.SEND_PROMOTIONAL_SMS,
  t.check_in_photo_id,
  t.HOUSEHOLD_SEQN
FROM Client t
LEFT OUTER JOIN HOUSEHOLD_ADDRESS a
ON a.household_addr_id = t.household_addr_id
WHERE (t.IS_ACTIVE     ='Y'
AND t.IS_DECEASED      ='N'
AND UPPER(t.email) LIKE 'ROBERT.KAEV@TALLINK.EE%'  -- email
AND t.household_id IN
  (SELECT hp.household_id
  FROM household_phone hp
  WHERE hp.phone_number='53493550'  -- Phone number
  )
AND EXISTS
  (SELECT cp.client_id
  FROM CLIENT_PROGRAM cp
  WHERE TRUNC(sysdate) BETWEEN cp.DATE_FROM AND cp.DATE_TO
  AND t.client_id    =cp.client_id
  AND cp.club_account='15429375'  -- CO ACCOUNT
  ) )
