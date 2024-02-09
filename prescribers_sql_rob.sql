-- Prescribers Database

/*
For this exericse, you'll be working with a database derived from the Medicare Part D Prescriber Public Use File. More information about the data is contained in the Methodology PDF file. See also the included entity-relationship diagram.
*/

				--1--
				
--		✅a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- SELECT pr.npi, total_claim_count
-- FROM prescriber AS pr
-- INNER JOIN prescription as pn
-- ON pr.npi = pn.npi
-- ORDER BY total_claim_count DESC;

		--💻NPI #1912011792 had the highest total number of claims at 4538

--		✅b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.

-- SELECT pr.npi, pr.nppes_provider_first_name AS first_name, pr.nppes_provider_last_org_name AS last_name, pr.specialty_description, pn.total_claim_count AS claims
-- FROM prescriber AS pr
-- INNER JOIN prescription as pn
-- ON pr.npi = pn.npi
-- ORDER BY total_claim_count DESC;

		--💻David Coffey was the name of the top prescriber
		
				--2--
			
--		✅a. Which specialty had the most total number of claims (totaled over all drugs)?

-- SELECT pr.specialty_description, SUM(pn.total_claim_count) AS claims
-- FROM prescriber AS pr
-- INNER JOIN prescription as pn
-- ON pr.npi = pn.npi
-- GROUP BY specialty_description
-- ORDER BY claims DESC;

		--💻Family Practice had the most total claims with 9,752,347
		
--		✅b. Which specialty had the most total number of claims for opioids?

-- SELECT specialty_description, SUM(total_claim_count)
-- FROM prescriber AS pr
-- FULL JOIN prescription AS pn
-- ON pr.npi=pn.npi
-- RIGHT JOIN drug as d
-- ON d.drug_name=pn.drug_name
-- WHERE opioid_drug_flag='Y' OR long_acting_opioid_drug_flag='Y'
-- GROUP BY specialty_description
-- ORDER BY SUM DESC;

		--💻Nurse Practitioners had the most total claims for opioids and long acting opioids with 900,845.
		
--     c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--     d. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

				--3--
			
--		✅a. Which drug (generic_name) had the highest total drug cost?

-- SELECT pn.total_drug_cost, pn.drug_name, d.generic_name
-- FROM prescription AS pn
-- INNER JOIN drug AS d
-- ON pn.drug_name=d.drug_name
-- ORDER BY total_drug_cost DESC;

		--💻PIRFENIDONE had the highest total cost of $2,829,174.30
		
-- SELECT SUM(pn.total_drug_cost) AS sum, d.generic_name
-- FROM prescription AS pn
-- INNER JOIN drug AS d
-- ON pn.drug_name=d.drug_name
-- GROUP BY generic_name
-- ORDER BY sum DESC;		

		--💻The drug with the highest sum total expenditure is Insulin $104,264,066.35
		
--		✅b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.

-- SELECT ROUND(pn.total_drug_cost/pn.total_day_supply, 2) as daily_drug_cost, pn.drug_name, d.generic_name
-- FROM prescription AS pn
-- INNER JOIN drug AS d
-- ON pn.drug_name=d.drug_name
-- ORDER BY daily_drug_cost DESC;

		--💻IGG has the highest cost per day at $7144.11/day
		
				--4--
				
--		✅a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

-- SELECT drug_name,
-- 	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither' END AS drug_type
-- FROM drug;

--		✅b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- SELECT 
-- 	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither' END AS drug_type,
-- 	SUM(p.total_drug_cost) AS money
-- FROM drug AS d
-- LEFT JOIN prescription AS p
-- ON d.drug_name=p.drug_name
-- GROUP BY drug_type;

		--💻The total amount spent on opioids was $105,080,626.37. By comparison only $38,435,121.26 was spent on antibiotics.

				--5--
				
--		✅a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.

-- SELECT DISTINCT cb.cbsaname
-- FROM cbsa AS cb
-- INNER JOIN fips_county AS fi
-- ON fi.fipscounty=cb.fipscounty
-- WHERE fi.state='TN';

		--💻There are 10 CBSA's in Tennessee.
		
--		✅b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

-- SELECT c.cbsaname, SUM(p.population) AS combined_pop
-- FROM cbsa AS c
-- INNER JOIN population AS p
-- ON c.fipscounty=p.fipscounty
-- GROUP BY c.cbsaname
-- ORDER BY combined_pop DESC;

		--💻Nashville CBSA is the largest combined population with 1,830,410 and Morristown has the smallest with 116,352.

--		✅c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- SELECT f.county, p.population
-- FROM fips_county AS f
-- FULL JOIN population AS p
-- ON f.fipscounty=p.fipscounty
-- WHERE f.state='TN'
-- 	AND f.fipscounty NOT IN 
-- 	(SELECT c.fipscounty
-- 	FROM cbsa AS c)
-- ORDER BY p.population DESC;

		--💻Sevier County is the most populated county not included in a CBSA with 95,523.

				--6--
				
--		✅a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT drug_name, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY drug_name
HAVING SUM(total_claim_count)>=3000
ORDER BY total_claims DESC;

		--💻507 drugs total at least 3000 claims

--		✅b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

SELECT p.drug_name, SUM(p.total_claim_count) AS total_claims,
	CASE WHEN d.opioid_drug_flag='Y' THEN 'opioid'
	ELSE '' END AS opioid
FROM prescription as p
RIGHT JOIN drug as d
ON p.drug_name=d.drug_name
GROUP BY p.drug_name, opioid
HAVING SUM(total_claim_count)>=3000
ORDER BY opioid DESC, total_claims DESC;

		--💻17 of the drugs with at least 3000 claims are opioids
		
--		c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

 
				--7--
				
--	The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.

--		a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.



--		b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).



--		c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.


