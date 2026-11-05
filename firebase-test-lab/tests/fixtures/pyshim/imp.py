# Minimal replacement for the removed `imp` module (Python >= 3.12).
# Only added to PYTHONPATH when the runner's python lacks `imp`.
import importlib.machinery
import importlib.util


def load_source(name, path):
    loader = importlib.machinery.SourceFileLoader(name, path)
    spec = importlib.util.spec_from_loader(name, loader)
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module
