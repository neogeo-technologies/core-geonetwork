

-- 3.7.0 https://github.com/geonetwork/core-geonetwork/blob/master/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v370/migrate-default.sql

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/coverPdf', '', 0, 12500, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/introPdf', '', 0, 12501, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/tocPage', 'false', 2, 12502, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/headerLeft', '{siteInfo}', 0, 12504, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/headerRight', '', 0, 12505, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/footerLeft', '', 0, 12506, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/footerRight', '{date}', 0, 12507, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/pdfReport/pdfName', 'metadata_{datetime}.pdf', 0, 12507, 'n');

UPDATE Metadata SET data = replace(data, 'http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml', 'http://standards.iso.org/iso/19139/resources/gmxCodelists.xml') WHERE data LIKE '%http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml%' AND schemaId = 'iso19139';

-- Update GML namespace for moving from ISO19139:2005 to ISO19139:2007
UPDATE Metadata SET data = replace(data, '"http://www.opengis.net/gml"', '"http://www.opengis.net/gml/3.2"') WHERE data LIKE '%"http://www.opengis.net/gml"%' AND schemaId = 'iso19139';

-- Unset 2005 schemaLocation
UPDATE Metadata SET data = replace(data, ' xsi:schemaLocation="http://www.isotc211.org/2005/gmd https://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/gmx https://www.isotc211.org/2005/gmx/gmx.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd"', '') WHERE data LIKE '%xsi:schemaLocation="http://www.isotc211.org/2005/gmd https://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/gmx https://www.isotc211.org/2005/gmx/gmx.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd%';

UPDATE Settings SET internal='n' WHERE name='system/server/securePort';
UPDATE Settings SET internal='n' WHERE name='system/server/port';


UPDATE metadata SET data = replace(data, '<gmd:version gco:nilReason="missing">', '<gmd:version gco:nilReason="unknown">') WHERE  data LIKE '%<gmd:version gco:nilReason="missing">%';


UPDATE Settings SET  position = position + 1 WHERE name = 'metadata/workflow/draftWhenInGroup';
UPDATE Settings SET  position = position + 1 WHERE name = 'metadata/workflow/allowPublishInvalidMd';
UPDATE Settings SET  position = position + 1 WHERE name = 'metadata/workflow/automaticUnpublishInvalidMd';
UPDATE Settings SET  position = position + 1 WHERE name = 'metadata/workflow/forceValidationOnMdSave';
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/workflow/enable', 'false', 2, 100002, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/workflow/allowSumitApproveInvalidMd', 'true', 2, 100004, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/workflow/allowPublishNonApprovedMd', 'true', 2, 100005, 'n');




-- 3.8.1 https://github.com/geonetwork/core-geonetwork/blob/master/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v381/migrate-default.sql

-- 3.8.2 https://github.com/geonetwork/core-geonetwork/blob/master/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v382/migrate-default.sql

ALTER TABLE sources ADD COLUMN creationdate varchar(30);
ALTER TABLE sources ADD COLUMN filter varchar(255);
ALTER TABLE sources ADD COLUMN groupowner integer;
ALTER TABLE sources ADD COLUMN logo varchar(255);
ALTER TABLE sources ADD COLUMN servicerecord varchar(255);
ALTER TABLE sources ADD COLUMN type varchar(255);
ALTER TABLE sources ADD COLUMN uiconfig varchar(255);

UPDATE Sources SET type = 'portal' WHERE type IS null AND uuid = (SELECT value FROM settings WHERE name = 'system/site/siteId');
UPDATE Sources SET type = 'harvester' WHERE type IS null AND uuid != (SELECT value FROM settings WHERE name = 'system/site/siteId');

UPDATE Settings SET internal = 'y' WHERE name = 'system/publication/doi/doipassword';

-- 3.8.3 https://github.com/geonetwork/core-geonetwork/blob/master/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v383/migrate-default.sql

-- 3.9.0 https://github.com/geonetwork/core-geonetwork/blob/master/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v390/migrate-default.sql

-- 3.10.1 https://github.com/geonetwork/core-geonetwork/blob/master/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v3101/migrate-default.sql
DELETE FROM cswservercapabilitiesinfo;
DELETE FROM Settings WHERE name = 'system/csw/contactId';
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/csw/capabilityRecordUuid', '-1', 0, 1220, 'y');

-- 3.10.2 https://github.com/geonetwork/core-geonetwork/blob/master/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v3102/migrate-default.sql

-- 3.10.3 https://github.com/geonetwork/core-geonetwork/blob/3.10.x/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v3103/migrate-default.sql

ALTER TABLE groupsdes ALTER COLUMN label TYPE varchar(255);
ALTER TABLE sourcesdes ALTER COLUMN label TYPE varchar(255);
ALTER TABLE schematrondes ALTER COLUMN label TYPE varchar(255);

-- New setting for server timezone
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/timeZone', '', 0, 260, 'n');


-- 3.10.4 https://github.com/geonetwork/core-geonetwork/blob/3.10.x/web/src/main/webapp/WEB-INF/classes/setup/sql/migrate/v3104/migrate-default.sql

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/users/identicon', 'gravatar:mp', 0, 9110, 'n');

UPDATE Settings SET value='3.10.5' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';



-- Spécifique Othu

UPDATE settings SET value = '80' WHERE name = 'system/server/port';

-- Turn off debug log level
UPDATE settings SET value = 'log4j.xml' WHERE name = 'system/server/log';

UPDATE settings SET value = 'false' WHERE name = 'system/searchStats/enable';
UPDATE settings SET value = 'false' WHERE name = 'system/xlinkResolver/enable';
UPDATE settings SET value = 'false' WHERE name = 'system/autodetect/enable';
UPDATE settings SET value = 'false' WHERE name = 'system/requestedLanguage/preferUiLanguage';

UPDATE settings SET value = 'https://inspire.ec.europa.eu/validator/' WHERE name = 'system/inspire/remotevalidation/url';

DELETE FROM settings WHERE name = 'ui/config';
