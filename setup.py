from setuptools import setup, find_packages

setup(
    name='pymanager',
    version='1.0',
    install_requires=[
        'Click',
        'Flask',
        'mysqlclient',
        'SQLAlchemy',
        'tabulate',
        'pytest',
    ],
    entry_points='''
        [console_scripts]
        pymanager=pymanager.main:root
    ''',
    packages=find_packages(),
)
