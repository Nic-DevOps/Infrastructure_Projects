# 🌾 BrAPI-FastAPI Bridge

## 🚀 Overview

**BrAPI-FastAPI Bridge** is a lightweight middleware service built with [FastAPI](https://fastapi.tiangolo.com/) that connects to [BrAPI-compliant](https://brapi.org) servers such as [Breedbase](https://breedbase.org), providing simplified and filtered access to plant breeding data like studies, traits, phenotypes, and germplasm.

This bridge helps researchers and bioinformaticians:

* Query studies, observation units, and observations more easily
* Flatten and export phenotyping data to CSV
* Fetch germplasm pedigree and trait metadata
* Integrate into visualization dashboards or data pipelines

---

## 🧰 Technologies

* **FastAPI** – Async Python web framework
* **httpx** – For calling remote BrAPI endpoints asynchronously
* **Pydantic** – Schema validation and typed response models
* **Pandas** – Optional: data cleaning and CSV export
* **Docker** – Containerization and reproducible deployments

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
```

---

## 🔌 Example Routes

| Route                          | Description                          |
| ------------------------------ | ------------------------------------ |
| `GET /programs`                | List available breeding programs     |
| `GET /studies/{program_id}`    | List trials/studies within a program |
| `GET /phenotypes/{study_id}`   | Fetch flattened phenotype data       |
| `POST /export/csv`             | Export phenotype table to CSV        |
| `GET /traits/{study_id}`       | Get list of traits used in a study   |
| `GET /pedigree/{germplasm_id}` | Fetch germplasm pedigree tree        |

---

## 📦 Setup

### 🐍 Install locally

```bash
git clone https://github.com/your-username/brapi-fastapi-bridge.git
cd brapi-fastapi-bridge
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### 🐳 Run with Docker

```bash
docker build -t brapi-bridge .
docker run -p 8000:8000 brapi-bridge
```

---

## 🔄 Example Workflow

1. Visit `http://localhost:8000/docs` for interactive Swagger UI
2. Use `GET /studies/{program_id}` to find a relevant study
3. Call `GET /phenotypes/{study_id}` to fetch raw data
4. Use `POST /export/csv` to download a cleaned version
5. Optionally integrate this with your ML pipeline or data store

---

## 🧠 Future Enhancements

* Add Redis caching for repeated BrAPI calls
* Support for pagination & batch requests
* GCS/S3 export integration
* Auth layer for multi-user deployment

---

## 📚 References

* [BrAPI Specification](https://brapi.org/specification)
* [Breedbase](https://breedbase.org)
* [FastAPI Docs](https://fastapi.tiangolo.com/)
* [BrAPPs](https://www.brapi.org/brapps)

---

## 🧪 Example Use Case

> "Flatten phenotype data from a multi-location study in Breedbase, retrieve only NDVI and yield, and export a cleaned `.csv` for model training."

