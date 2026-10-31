import llm


def test_read_version():
    assert llm.read_version() == "1.1.0"


def test_read_version_when_file_is_missing(monkeypatch, tmp_path):
    missing_file = tmp_path / "version.txt"
    monkeypatch.setattr(llm, "VERSION_FILE", missing_file)

    assert llm.read_version() == "0.0.0"
