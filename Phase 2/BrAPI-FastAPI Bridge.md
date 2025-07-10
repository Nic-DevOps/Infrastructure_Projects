# 🌾 BrAPI-FastAPI Bridge

## 🚀 Overview

**BrAPI-FastAPI Bridge** is a lightweight middleware service built with [FastAPI](https://fastapi.tiangolo.com/) that connects to [BrAPI-compliant](https://brapi.org) servers such as [Breedbase](https://breedbase.org), providing simplified and filtered access to plant breeding data like studies, traits, phenotypes, and germplasm.

This bridge helps researchers and bioinformaticians:

- Query studies, observation units, and observations more easily
- Flatten and export phenotyping data to CSV
- Fetch germplasm pedigree and trait metadata
- Integrate into visualization dashboards or data pipelines

---

## 🧰 Technologies

- **FastAPI** – Async Python web framework
- **httpx** – For calling remote BrAPI endpoints asynchronously
- **Pydantic** – Schema validation and typed response models
- **Pandas** – Optional: data cleaning and CSV export
- **Docker** – Containerization and reproducible deployments

---

## 📁 Directory Structure

```plaintext
brapi-fastapi-bridge/
├── app/
│   ├── main.py             # FastAPI app with routes
│   ├── brapi_client.py     # Async BrAPI request wrapper
│   ├── models.py           # Pydantic schemas
│   └── utils.py            # Data flattening and transformation
├── tests/
│   └── test_endpoints.py   # Unit tests for routes
├── requirements.txt
├── Dockerfile
└── README.md
