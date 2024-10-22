+++
title = "Applying Hyperledger in Healthcare"
slug = "applying-hyperledger-in-healthcare"
date = "2017-12-10"
+++

> On December 2nd, I attended Blue Hack XP, a data science hackathon that brought together programmers, data scientists, designers, healthcare professionals, and other technology development experts.

## Challenges and Ideas

Upon receiving access to data provided by the Paraná Department of Health and Hospitals, we ensured that no individual was identifiable and strictly adhered to the user agreement, which permitted data use only during the event. We began analyzing the data to extract relevant insights, and one of the key areas we decided to focus on was itinerant care and spending within the public health system. It quickly became apparent that the information across various systems lacked standardization, hindering interoperability.

From the outset of the event, our blockchain development team was exploring how Hyperledger could be integrated into our solution, and this is when we identified the perfect opportunity. Part of our team dedicated time to standardizing the most frequently used fields in the healthcare systems’ tables and creating the initial R scripts. Meanwhile, another segment of the team began setting up an initial and functional environment for the blockchain solution.

## Blockchain + Health Data

Our healthcare-focused blockchain solution enables organizations such as hospitals, clinics, universities, governmental secretariats, or any other authorized entities to access a super-secure and virtually unbreakable data network that only blockchain technology can provide. In summary:

- Fully Distributed and Secure Database: An enterprise-grade database that builds trust among involved parties by being fully distributed and secure.
- Consensus Algorithm: Pre-established rules ensure the security and distribution of transactions.
- Immutable Data: All participants within the network hold identical copies of the data, which cannot be altered or centralized.
- Comprehensive Ledger: The ledger stores all transactions made by any network member, and only authorized members can access data created in encrypted form.

## Integrations and Legacy Systems

One of the most significant challenges any new system faces is integration into environments with existing legacy systems. To address this, we adopted a simple REST API, facilitating the easy addition of new patient entries and care data to the system. This approach allows any legacy system to integrate by simply making HTTP calls. Additionally, to our surprise, Hyperledger Composer provided a complete and well-documented REST API out of the box, significantly simplifying the integration process.

## Shared Data Science

Furthermore, our primary goal of unifying databases and ensuring data distribution led us to emphasize the need for reliable, well-documented, and ready-to-use data from any authorized network member. With the right elements in place, we incorporated the ability to share code developed in R or Python within the blockchain. This innovative feature enables all network participants to utilize and share their insights from data and research effectively.

## Welcome SISSA

The health information system utilizing blockchain technology unites, integrates, and securely distributes health data across Brazil, exponentially enhancing data science integration and sharing.

## The Team

Participating in hackathons is always a blend of fun, challenges, and significant learning opportunities. Our team thrived in this dynamic environment, overcoming obstacles and collaborating effectively to develop a robust and impactful solution.